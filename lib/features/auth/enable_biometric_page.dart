import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/secure_storage.dart';

class EnableBiometricPage extends ConsumerStatefulWidget {
  const EnableBiometricPage({super.key});

  @override
  ConsumerState<EnableBiometricPage> createState() => _EnableBiometricPageState();
}

class _EnableBiometricPageState extends ConsumerState<EnableBiometricPage> {
  bool _fingerprint = false;
  bool _face = false;
  bool _saving = false;

  void _toggleFingerprint() => setState(() => _fingerprint = !_fingerprint);
  void _toggleFace() => setState(() => _face = !_face);

  Future<void> _finish({required bool enable}) async {
    setState(() => _saving = true);
    final storage = SecureStorage();
    await storage.write('biometricEnabled', enable.toString());
    await storage.write('biometricFingerprint', _fingerprint.toString());
    await storage.write('biometricFace', _face.toString());
    if (!mounted) return;
    context.go('/join-group');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enable biometric login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Allow login with your fingerprint or face scan to quickly and securely access the app.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              children: [
                ChoiceChip(
                  label: const Text('Fingerprint'),
                  selected: _fingerprint,
                  onSelected: (_) => _toggleFingerprint(),
                ),
                ChoiceChip(
                  label: const Text('Face ID'),
                  selected: _face,
                  onSelected: (_) => _toggleFace(),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_saving) const CircularProgressIndicator(),
            if (!_saving)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _finish(enable: true),
                      child: const Text('ENABLE'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _finish(enable: false),
                      child: const Text('NOT NOW'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
