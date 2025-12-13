import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/join_repository.dart';
import '../network/api_endpoints.dart';

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

class QuizResultItem {
  QuizResultItem({
    required this.id,
    required this.score,
    required this.passed,
    this.completedAt,
    required this.learningModuleId,
    required this.subjectId,
  });

  final String id;
  final int score;
  final bool passed;
  final DateTime? completedAt;
  final String learningModuleId;
  final String subjectId;

  factory QuizResultItem.fromJson(Map<String, dynamic> json) {
    final learningModule = json['learning_module'] as Map<String, dynamic>?;
    final subject = json['subject'] as Map<String, dynamic>?;
    return QuizResultItem(
      id: json['id'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      passed: json['passed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      learningModuleId: learningModule?['id'] as String? ?? '',
      subjectId: subject?['id'] as String? ?? '',
    );
  }
}

enum SyncStatus {
  online,
  offline,
  syncing,
  synced,
}

class QuizSyncService {
  QuizSyncService._();
  static final QuizSyncService instance = QuizSyncService._();

  static const _queueKey = 'quiz_results_queue';

  Dio get _dio => DioProviderSingleton.dio;
  final _statusController = StreamController<SyncStatus>.broadcast();
  final _queueController = StreamController<bool>.broadcast();
  final _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isOnline = true;
  bool _isSyncing = false;

  Stream<SyncStatus> get statusStream => _statusController.stream;
  Stream<bool> get pendingStream => _queueController.stream;
  bool get isOnline => _isOnline;

  void init() {
    _connectivitySub?.cancel();
    _connectivitySub =
        _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _onConnectivityChanged(results);
    } catch (e) {
      debugPrint('QuizSyncService: Failed to check connectivity: $e');
      _isOnline = true;
      _statusController.add(SyncStatus.online);
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
    _statusController.close();
    _queueController.close();
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline =
        results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);

    if (_isOnline && !wasOnline) {
      _syncQueue();
    } else if (!_isOnline) {
      _statusController.add(SyncStatus.offline);
    } else {
      _statusController.add(SyncStatus.online);
    }
  }

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
      ApiEndpoints.studentQuizResults,
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
    _queueController.add(queue.isNotEmpty);
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

    await prefs.setString(_queueKey, jsonEncode(failed));

    _isSyncing = false;
    _queueController.add(failed.isNotEmpty);

    if (failed.isEmpty && queue.isNotEmpty) {
      _statusController.add(SyncStatus.synced);
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

  Future<bool> hasPendingItems() async {
    final prefs = await SharedPreferences.getInstance();
    final queue = _getQueue(prefs);
    final hasItems = queue.isNotEmpty;
    _queueController.add(hasItems);
    return hasItems;
  }

  Future<void> trySyncNow() async {
    if (_isOnline) {
      await _syncQueue();
    }
  }

  Future<List<QuizResultItem>> fetchQuizResults() async {
    try {
      final response = await _dio.get(ApiEndpoints.studentQuizResults);
      final data = response.data as Map<String, dynamic>;
      if (data['success'] != true) return [];

      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((item) => QuizResultItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('QuizSyncService: Failed to fetch quiz results: $e');
      return [];
    }
  }
}
