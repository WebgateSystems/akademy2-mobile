import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/auth/auth_provider.dart';
import 'core/db/isar_service.dart';
import 'core/utils/orientation_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OrientationUtils.lockPortrait();

  final isarService = IsarService();
  await isarService.init();

  final container = ProviderContainer();
  await container.read(authProvider.notifier).load();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
