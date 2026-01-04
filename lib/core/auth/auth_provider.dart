import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/secure_storage.dart';
import '../db/isar_service.dart';
import '../download/download_manager.dart';
import '../network/api_endpoints.dart';
import '../network/dio_provider.dart';
import '../services/student_api_service.dart';
import 'pending_join_storage.dart';

enum StudentEnrollmentStatusType {
  unknown,
  needsSchool,
  waitingForClasses,
  ready,
}

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isUnlocked;
  final String? userId;
  final String? schoolId;
  final bool hasPendingJoin;
  final StudentEnrollmentStatusType studentStatus;

  const AuthState({
    required this.isAuthenticated,
    this.isLoading = false,
    this.isUnlocked = false,
    this.userId,
    this.schoolId,
    this.hasPendingJoin = false,
    this.studentStatus = StudentEnrollmentStatusType.unknown,
  });

  bool get needsSchoolBinding =>
      studentStatus == StudentEnrollmentStatusType.needsSchool;

  bool get isWaitingForApproval =>
      studentStatus == StudentEnrollmentStatusType.waitingForClasses;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isUnlocked,
    String? userId,
    String? schoolId,
    bool clearSchoolId = false,
    bool? hasPendingJoin,
    StudentEnrollmentStatusType? studentStatus,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      userId: userId ?? this.userId,
      schoolId: clearSchoolId ? null : (schoolId ?? this.schoolId),
      hasPendingJoin: hasPendingJoin ?? this.hasPendingJoin,
      studentStatus: studentStatus ?? this.studentStatus,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorage _storage = SecureStorage();
  final Ref ref;

  AuthNotifier(this.ref)
      : super(const AuthState(isAuthenticated: false, isLoading: true));

  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    final token = await _storage.read('accessToken');
    if (token == null) {
      await _storage.delete('schoolId');
    }
    var schoolId = await _storage.read('schoolId');
    final pendingJoinId =
        schoolId == null ? await PendingJoinStorage.readId() : null;
    debugPrint('AuthNotifier.load: token=$token schoolId=$schoolId pendingId=$pendingJoinId');
    final fallbackStatus = schoolId != null
        ? StudentEnrollmentStatusType.ready
        : StudentEnrollmentStatusType.needsSchool;
    var enrollmentStatus = token != null
        ? await _determineEnrollmentStatus(fallback: fallbackStatus)
        : StudentEnrollmentStatusType.unknown;
    if (enrollmentStatus == StudentEnrollmentStatusType.waitingForClasses &&
        (pendingJoinId ?? '').isEmpty) {
      await _storage.delete('schoolId');
      schoolId = null;
      enrollmentStatus = StudentEnrollmentStatusType.needsSchool;
    }
    state = AuthState(
      isAuthenticated: token != null,
      isLoading: false,
      isUnlocked: false,
      userId: token != null ? 'me' : null,
      schoolId: schoolId,
      hasPendingJoin: (pendingJoinId ?? '').isNotEmpty,
      studentStatus: enrollmentStatus,
    );
  }

  Future<void> login(String phone, String pin) async {
    state = state.copyWith(isLoading: true);
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.post(
        ApiEndpoints.session,
        data: {
          'user': {
            'phone': phone,
            'password': pin,
          },
        },
      );

      if ((resp.statusCode == 200 || resp.statusCode == 201) &&
          resp.data != null) {
        final accessToken = resp.data['access_token'] as String?;
        final data = resp.data['data'] as Map<String, dynamic>?;
        final attributes = data?['attributes'] as Map<String, dynamic>?;
        final userId = attributes?['id'] as String? ?? data?['id'] as String?;
        final refreshToken = resp.data['refreshToken'] as String?;
        if (accessToken != null) {
          var schoolId = attributes?['school_id'] as String?;
          await _resetCacheIfOwnerChanged(userId ?? phone);
          final pendingJoinId = schoolId == null
              ? await PendingJoinStorage.readId()
              : null;
          debugPrint('AuthNotifier.login: userId=$userId phone=$phone schoolId=$schoolId pendingId=$pendingJoinId');
          await _storage.write('accessToken', accessToken);
          if (refreshToken != null) {
            await _storage.write('refreshToken', refreshToken);
          }
          if (userId != null) {
            await _storage.write('userId', userId);
          }
          await saveUserProfile(
            attributes,
            email: attributes?['email'] as String?,
            phone: attributes?['phone'] as String? ?? phone,
            pin: pin,
          );
          final fallbackStatus = schoolId != null
              ? StudentEnrollmentStatusType.ready
              : StudentEnrollmentStatusType.needsSchool;
          var enrollmentStatus =
              await _determineEnrollmentStatus(fallback: fallbackStatus);
          if (enrollmentStatus ==
                  StudentEnrollmentStatusType.waitingForClasses &&
              (pendingJoinId ?? '').isEmpty) {
            await _storage.delete('schoolId');
            schoolId = null;
            enrollmentStatus = StudentEnrollmentStatusType.needsSchool;
          }
          state = AuthState(
            isAuthenticated: true,
            isUnlocked: true,
            userId: userId ?? phone,
            schoolId: schoolId,
            isLoading: false,
            hasPendingJoin: (pendingJoinId ?? '').isNotEmpty,
            studentStatus: enrollmentStatus,
          );
          _invalidateDashboard();
          return;
        }
      }
      state = state.copyWith(isLoading: false);
      throw Exception('Invalid response: missing access_token');
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setTokens(String accessToken,
      {String? refreshToken, String? userId, String? schoolId}) async {
    await _resetCacheIfOwnerChanged(userId);
    var effectiveSchoolId = schoolId;
    final pendingJoinId =
        effectiveSchoolId == null ? await PendingJoinStorage.readId() : null;
    debugPrint('AuthNotifier.setTokens: userId=$userId schoolId=$effectiveSchoolId pendingId=$pendingJoinId');
    await _storage.write('accessToken', accessToken);
    if (refreshToken != null) {
      await _storage.write('refreshToken', refreshToken);
    }
    if (effectiveSchoolId != null) {
      await _storage.write('schoolId', effectiveSchoolId);
    }
    final fallbackStatus = effectiveSchoolId != null
        ? StudentEnrollmentStatusType.ready
        : StudentEnrollmentStatusType.needsSchool;
    var enrollmentStatus =
        await _determineEnrollmentStatus(fallback: fallbackStatus);
    if (enrollmentStatus == StudentEnrollmentStatusType.waitingForClasses &&
        (pendingJoinId ?? '').isEmpty) {
      await _storage.delete('schoolId');
      effectiveSchoolId = null;
      enrollmentStatus = StudentEnrollmentStatusType.needsSchool;
    }
    state = AuthState(
      isAuthenticated: true,
      isUnlocked: true,
      isLoading: false,
      userId: userId ?? 'me',
      schoolId: effectiveSchoolId,
      hasPendingJoin: (pendingJoinId ?? '').isNotEmpty,
      studentStatus: enrollmentStatus,
    );
    _invalidateDashboard();
  }

  Future<void> updateSchoolId(String schoolId) async {
    await _storage.write('schoolId', schoolId);
    state = state.copyWith(schoolId: schoolId);
  }

  void markAuthenticated({String? userId, String? schoolId}) {
    state = AuthState(
      isAuthenticated: true,
      isUnlocked: true,
      isLoading: false,
      userId: userId,
      schoolId: schoolId ?? state.schoolId,
      hasPendingJoin: state.hasPendingJoin,
      studentStatus: state.studentStatus,
    );
  }

  Future<void> clearSchoolBinding() async {
    await _storage.delete('schoolId');
    state = state.copyWith(
      clearSchoolId: true,
      studentStatus: StudentEnrollmentStatusType.needsSchool,
    );
  }

  void markUnlocked() {
    state = state.copyWith(
      isAuthenticated: true,
      isUnlocked: true,
      isLoading: false,
      hasPendingJoin: state.hasPendingJoin,
    );
  }

  void setPendingJoin(bool value) {
    state = state.copyWith(hasPendingJoin: value);
  }

  void requireUnlock() {
    if (state.isAuthenticated && state.isUnlocked) {
      state = state.copyWith(isUnlocked: false);
    }
  }

  Future<void> logout({bool clearPendingJoin = false}) async {
    final pendingJoinId =
        clearPendingJoin ? null : await PendingJoinStorage.readId();
    debugPrint(
        'AuthNotifier.logout: clearPendingJoin=$clearPendingJoin pendingIdBefore=$pendingJoinId');
    await _storage.delete('accessToken');
    await _storage.delete('refreshToken');
    await _storage.delete('schoolId');
    if (clearPendingJoin) {
      await _clearPendingJoinStorage();
    }
    _invalidateDashboard();
    state = AuthState(
      isAuthenticated: false,
      isLoading: false,
      isUnlocked: false,
      hasPendingJoin: !clearPendingJoin && (pendingJoinId?.isNotEmpty ?? false),
      studentStatus: StudentEnrollmentStatusType.needsSchool,
    );
  }

  Future<bool> refreshAccessToken() async {
    await logout();
    return false;
  }

  Future<String?> getAccessToken() async {
    return await _storage.read('accessToken');
  }

  Future<void> saveUserProfile(
    Map<String, dynamic>? attrs, {
    String? email,
    String? phone,
    String? pin,
  }) async {
    final storage = _storage;
    final firstName = attrs?['first_name'] as String?;
    final lastName = attrs?['last_name'] as String?;
    final birthdate =
        attrs?['birthdate'] as String? ?? attrs?['birth_date'] as String?;
    final schoolId = attrs?['school_id'] as String?;
    final language = attrs?['locale'] as String?;
    final metaPin = attrs?['metadata'] is Map<String, dynamic>
        ? (attrs?['metadata'] as Map<String, dynamic>)['pin'] as String?
        : null;

    if (firstName != null) await storage.write('firstName', firstName);
    if (lastName != null) await storage.write('lastName', lastName);
    if (birthdate != null) await storage.write('dob', birthdate);
    if (schoolId != null) await storage.write('schoolId', schoolId);
    if (language != null) await storage.write('language', language);
    if (email != null) await storage.write('email', email);
    if (phone != null) await storage.write('phone', phone);
    if (pin != null) await storage.write('userPin', pin);
    if (metaPin != null) await storage.write('userPin', metaPin);
  }

  Future<StudentEnrollmentStatusType> _determineEnrollmentStatus({
    StudentEnrollmentStatusType? fallback,
  }) async {
    try {
      final status = await ref
          .read(studentApiServiceProvider)
          .fetchDashboardStatus();
      if (!status.hasSchoolToken) {
        return StudentEnrollmentStatusType.needsSchool;
      }
      if (!status.hasClasses) {
        return StudentEnrollmentStatusType.waitingForClasses;
      }
      return StudentEnrollmentStatusType.ready;
    } catch (e, stack) {
      debugPrint('AuthNotifier: Failed to fetch dashboard status: $e\n$stack');
      if (fallback != null) return fallback;
      if (state.schoolId == null) {
        return StudentEnrollmentStatusType.needsSchool;
      }
      return StudentEnrollmentStatusType.ready;
    }
  }

  void _invalidateDashboard() {
    ref.invalidate(dashboardSubjectsProvider);
  }

  Future<void> _clearPendingJoinStorage() async {
    await PendingJoinStorage.clearCurrent();
  }

  Future<void> _resetCacheIfOwnerChanged(String? userId) async {
    final existing = await _storage.read('cacheOwnerId');
    if (userId == null || userId.isEmpty) {
      // If we cannot identify the owner, leave existing caches/pending data intact.
      return;
    }

    if (existing == null) {
      await PendingJoinStorage.migrateAnonToOwner(userId);
    } else if (existing != userId) {
      await IsarService().clearAll();
      await clearAllDownloads();
    } else {
      return;
    }

    await _storage.write('cacheOwnerId', userId);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
