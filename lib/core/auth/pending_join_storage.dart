import 'package:flutter/foundation.dart';

import '../storage/secure_storage.dart';

/// Stores pending join data per cache owner to avoid leaking between users.
/// Keeps both owner-specific keys and a global key with owner metadata to
/// survive owner key changes.
class PendingJoinStorage {
  static final SecureStorage _storage = SecureStorage();
  static const _anonOwner = 'anon';
  static const _globalOwnerKey = 'pendingJoinOwner';
  static const _globalIdKey = 'pendingJoinId_global';
  static const _globalCodeKey = 'pendingJoinCode_global';

  static Future<String> _owner() async {
    return await _storage.read('cacheOwnerId') ?? _anonOwner;
  }

  static Future<void> save(String id, String code, {String? owner}) async {
    final effectiveOwner =
        (owner != null && owner.isNotEmpty) ? owner : await _owner();
    await _storage.write('pendingJoinId_$effectiveOwner', id);
    await _storage.write('pendingJoinCode_$effectiveOwner', code);
    await _storage.write(_globalOwnerKey, effectiveOwner);
    await _storage.write(_globalIdKey, id);
    await _storage.write(_globalCodeKey, code);
    debugPrint(
        'PendingJoinStorage: saved for owner=$effectiveOwner id=$id code=$code');
  }

  static Future<String?> readId({String? owner}) async {
    final effectiveOwner =
        (owner != null && owner.isNotEmpty) ? owner : await _owner();
    final key = 'pendingJoinId_$effectiveOwner';
    final id = await _storage.read(key);
    if (id != null && id.isNotEmpty) {
      debugPrint('PendingJoinStorage: readId hit owner=$effectiveOwner value=$id');
      return id;
    }

    final globalOwner = await _storage.read(_globalOwnerKey);
    if (globalOwner == effectiveOwner) {
      final globalId = await _storage.read(_globalIdKey);
      if (globalId != null && globalId.isNotEmpty) {
        debugPrint(
            'PendingJoinStorage: readId hit GLOBAL for owner=$effectiveOwner value=$globalId');
        return globalId;
      }
    }
    debugPrint('PendingJoinStorage: readId miss for owner=$effectiveOwner');
    return null;
  }

  static Future<String?> readCode({String? owner}) async {
    final effectiveOwner =
        (owner != null && owner.isNotEmpty) ? owner : await _owner();
    final key = 'pendingJoinCode_$effectiveOwner';
    final code = await _storage.read(key);
    if (code != null && code.isNotEmpty) {
      debugPrint(
          'PendingJoinStorage: readCode hit owner=$effectiveOwner value=$code');
      return code;
    }

    final globalOwner = await _storage.read(_globalOwnerKey);
    if (globalOwner == effectiveOwner) {
      final globalCode = await _storage.read(_globalCodeKey);
      if (globalCode != null && globalCode.isNotEmpty) {
        debugPrint(
            'PendingJoinStorage: readCode hit GLOBAL for owner=$effectiveOwner value=$globalCode');
        return globalCode;
      }
    }
    debugPrint('PendingJoinStorage: readCode miss for owner=$effectiveOwner');
    return null;
  }

  static Future<void> clearCurrent({String? owner}) async {
    final effectiveOwner =
        (owner != null && owner.isNotEmpty) ? owner : await _owner();
    await clearForOwner(effectiveOwner);
    final globalOwner = await _storage.read(_globalOwnerKey);
    if (globalOwner == effectiveOwner) {
      await _storage.delete(_globalOwnerKey);
      await _storage.delete(_globalIdKey);
      await _storage.delete(_globalCodeKey);
    }
    debugPrint('PendingJoinStorage: cleared owner=$effectiveOwner');
  }

  static Future<void> clearForOwner(String owner) async {
    await _storage.delete('pendingJoinId_$owner');
    await _storage.delete('pendingJoinCode_$owner');
  }

  /// If anonymous pending data exists and the first owner logs in, move it.
  static Future<void> migrateAnonToOwner(String owner) async {
    if (owner.isEmpty || owner == _anonOwner) return;
    final anonId = await _storage.read('pendingJoinId_$_anonOwner');
    final anonCode = await _storage.read('pendingJoinCode_$_anonOwner');
    if ((anonId?.isEmpty ?? true) && (anonCode?.isEmpty ?? true)) return;
    if (anonId != null && anonId.isNotEmpty) {
      await _storage.write('pendingJoinId_$owner', anonId);
    }
    if (anonCode != null && anonCode.isNotEmpty) {
      await _storage.write('pendingJoinCode_$owner', anonCode);
    }
    await clearForOwner(_anonOwner);
    await _storage.write(_globalOwnerKey, owner);
    if (anonId != null && anonId.isNotEmpty) {
      await _storage.write(_globalIdKey, anonId);
    }
    if (anonCode != null && anonCode.isNotEmpty) {
      await _storage.write(_globalCodeKey, anonCode);
    }
    debugPrint(
        'PendingJoinStorage: migrated anon pending to owner=$owner id=$anonId code=$anonCode');
  }
}
