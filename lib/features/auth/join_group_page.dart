import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/auth/join_repository.dart';
import '../../core/storage/secure_storage.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final _codeCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    _restorePending();
  }

  Future<void> _restorePending() async {
    final storage = SecureStorage();
    final pending = await storage.read('pendingJoinId');
    if (pending != null && pending.isNotEmpty && mounted) {
      context.go('/wait-approval');
    }
  }


  bool _submitting = false;
  bool _scanPaused = false;
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit => _codeCtrl.text.trim().isNotEmpty && !_submitting;

  Future<void> _submit() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final repo = JoinRepository();
      final pendingId = await repo.joinWithCode(code);
      await SecureStorage().write('pendingJoinId', pendingId);
      await SecureStorage().write('pendingJoinCode', code);
      if (!mounted) return;
      context.go('/wait-approval');
    } catch (e) {
      setState(() => _error = 'Failed to submit code: $e');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanPaused) return;
    final raw = capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (raw != null && raw.isNotEmpty) {
      setState(() {
        _scanPaused = true;
        _codeCtrl.text = raw;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join your group')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The last step. Enter the code or scan the QR code to join 🚀',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeCtrl,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Enter code',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    MobileScanner(
                      onDetect: _onDetect,
                      controller: MobileScannerController(torchEnabled: false),
                    ),
                    if (_scanPaused)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black45,
                          child: const Center(
                            child: Text(
                              'Code captured',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit ? _submit : null,
                child: _submitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
