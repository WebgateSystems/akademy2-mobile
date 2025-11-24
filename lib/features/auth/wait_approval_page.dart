import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/auth/join_repository.dart';
import '../../core/storage/secure_storage.dart';

class WaitApprovalPage extends ConsumerStatefulWidget {
  const WaitApprovalPage({super.key});

  @override
  ConsumerState<WaitApprovalPage> createState() => _WaitApprovalPageState();
}

class _WaitApprovalPageState extends ConsumerState<WaitApprovalPage> {
  Timer? _timer;
  String? _requestId;
  String? _code;
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    _loadPending();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPending() async {
    final storage = SecureStorage();
    final id = await storage.read('pendingJoinId');
    final code = await storage.read('pendingJoinCode');
    if (id == null || id.isEmpty) {
      if (mounted) context.go('/join-group');
      return;
    }
    setState(() {
      _requestId = id;
      _code = code;
    });
    _startPolling();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
    _poll();
  }

  Future<void> _poll() async {
    if (_requestId == null) return;
    final repo = JoinRepository();
    final status = await repo.checkStatus(_requestId!);
    if (!mounted) return;
    setState(() => _status = status.status);
    if (status.status == 'approved' && status.accessToken != null) {
      await repo.clearPending();
      _timer?.cancel();
      await ref.read(authProvider.notifier).setTokens(
            status.accessToken!,
            refreshToken: status.refreshToken,
          );
      if (!mounted) return;
      context.go('/home');
    }
  }

  Future<void> _retry() async {
    await JoinRepository().clearPending();
    if (!mounted) return;
    context.go('/join-group');
  }

  @override
  Widget build(BuildContext context) {
    final rejected = _status == 'rejected';
    return Scaffold(
      appBar: AppBar(title: const Text("Wait for teacher's approval")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your teacher will review your request soon - hang tight!',
              style: TextStyle(fontSize: 16),
            ),
            if (_code != null && _code!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text('Code: $_code'),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Status: '),
                Chip(label: Text(_status)),
              ],
            ),
            const Spacer(),
            if (rejected)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _retry,
                  child: const Text('Submit again'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
