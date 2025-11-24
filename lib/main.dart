import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/auth/auth_provider.dart';
import 'core/db/isar_service.dart';
import 'core/sync/sync_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar database
  final isarService = IsarService();
  await isarService.init();

  final container = ProviderContainer();
  await container.read(authProvider.notifier).load();
  await container.read(syncManagerProvider).bootstrap();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
