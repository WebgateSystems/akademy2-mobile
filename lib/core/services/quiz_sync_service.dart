import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/join_repository.dart';

/// Model for quiz result to be synced
class QuizResultPayload {
  QuizResultPayload({
    required this.learningModuleId,
    required this.score,
    this.details = const {},
  });

  final String learningModuleId;
  final int score;
  final Map<String, dynamic> details;

  Map<String, dynamic> toJson() => {
        'learning_module_id': learningModuleId,
        'score': score,
        'details': details,
      };

  factory QuizResultPayload.fromJson(Map<String, dynamic> json) {
    return QuizResultPayload(
      learningModuleId: json['learning_module_id'] as String,
      score: json['score'] as int,
      details: json['details'] as Map<String, dynamic>? ?? {},
    );
  }
}

/// Response from quiz result submission
class QuizResultResponse {
  QuizResultResponse({
    required this.success,
    this.id,
    this.score,
    this.passed,
    this.completedAt,
    this.message,
  });

  final bool success;
  final String? id;
  final int? score;
  final bool? passed;
  final DateTime? completedAt;
  final String? message;

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return QuizResultResponse(
      success: json['success'] as bool? ?? false,
      id: data?['id'] as String?,
      score: data?['score'] as int?,
      passed: data?['passed'] as bool?,
      completedAt: data?['completed_at'] != null
          ? DateTime.tryParse(data!['completed_at'] as String)
          : null,
      message: data?['message'] as String?,
    );
  }
}

/// Sync status for UI
enum SyncStatus {
  online,
  offline,
  syncing,
  synced,
}

/// Service for submitting quiz results with offline queue support
class QuizSyncService {
  QuizSyncService._();
  static final QuizSyncService instance = QuizSyncService._();

  static const _queueKey = 'quiz_results_queue';

  final Dio _dio = DioProviderSingleton.dio;
  final _statusController = StreamController<SyncStatus>.broadcast();
  final _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isOnline = true;
  bool _isSyncing = false;

  Stream<SyncStatus> get statusStream => _statusController.stream;
  bool get isOnline => _isOnline;

  /// Initialize connectivity monitoring
  void init() {
    _connectivitySub?.cancel();
    _connectivitySub =
        _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    // Check initial status
    _connectivity.checkConnectivity().then(_onConnectivityChanged);
  }

  void dispose() {
    _connectivitySub?.cancel();
    _statusController.close();
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline =
        results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);

    if (_isOnline && !wasOnline) {
      // Connection restored - try to sync
      _syncQueue();
    } else if (!_isOnline) {
      _statusController.add(SyncStatus.offline);
    } else {
      _statusController.add(SyncStatus.online);
    }
  }

  /// Submit quiz result - will queue if offline
  Future<QuizResultResponse?> submitResult(QuizResultPayload payload) async {
    if (_isOnline) {
      try {
        final response = await _sendToServer(payload);
        return response;
      } catch (e) {
        debugPrint('QuizSyncService: Failed to submit, queuing: $e');
        await _addToQueue(payload);
        _statusController.add(SyncStatus.offline);
        return null;
      }
    } else {
      await _addToQueue(payload);
      _statusController.add(SyncStatus.offline);
      return null;
    }
  }

  Future<QuizResultResponse> _sendToServer(QuizResultPayload payload) async {
    final response = await _dio.post(
      'v1/student/quiz_results',
      data: payload.toJson(),
    );
    return QuizResultResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> _addToQueue(QuizResultPayload payload) async {
    final prefs = await SharedPreferences.getInstance();
    final queue = _getQueue(prefs);
    queue.add(payload.toJson());
    await prefs.setString(_queueKey, jsonEncode(queue));
    debugPrint('QuizSyncService: Added to queue, total: ${queue.length}');
  }

  List<Map<String, dynamic>> _getQueue(SharedPreferences prefs) {
    final raw = prefs.getString(_queueKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> _syncQueue() async {
    if (_isSyncing) return;
    _isSyncing = true;

    final prefs = await SharedPreferences.getInstance();
    final queue = _getQueue(prefs);

    if (queue.isEmpty) {
      _isSyncing = false;
      _statusController.add(SyncStatus.online);
      return;
    }

    _statusController.add(SyncStatus.syncing);
    debugPrint('QuizSyncService: Syncing ${queue.length} items');

    final failed = <Map<String, dynamic>>[];

    for (final item in queue) {
      try {
        final payload = QuizResultPayload.fromJson(item);
        await _sendToServer(payload);
        debugPrint('QuizSyncService: Synced item');
      } catch (e) {
        debugPrint('QuizSyncService: Failed to sync item: $e');
        failed.add(item);
      }
    }

    // Save failed items back to queue
    await prefs.setString(_queueKey, jsonEncode(failed));

    _isSyncing = false;

    if (failed.isEmpty && queue.isNotEmpty) {
      _statusController.add(SyncStatus.synced);
      // Reset to online after showing synced message
      Future.delayed(const Duration(seconds: 3), () {
        if (_isOnline) {
          _statusController.add(SyncStatus.online);
        }
      });
    } else if (failed.isNotEmpty) {
      _statusController.add(SyncStatus.offline);
    } else {
      _statusController.add(SyncStatus.online);
    }
  }

  /// Check if there are pending items in queue
  Future<bool> hasPendingItems() async {
    final prefs = await SharedPreferences.getInstance();
    final queue = _getQueue(prefs);
    return queue.isNotEmpty;
  }

  /// Force sync attempt
  Future<void> trySyncNow() async {
    if (_isOnline) {
      await _syncQueue();
    }
  }
}
