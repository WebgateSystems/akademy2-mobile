import 'package:academy_2_app/app/view/base_wait_approval_page.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/auth/join_repository.dart';

class WaitApprovalPage extends ConsumerWidget {
  const WaitApprovalPage({super.key});

  Future<void> _retry(BuildContext context, WidgetRef ref) async {
    await JoinRepository().clearPending();
    ref.read(authProvider.notifier).setPendingJoin(false);
    if (!context.mounted) return;
    context.go('/join-group');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    return BaseWaitApprovalPage(
      title: loc.waitApprovalTitle,
      subtitle: loc.waitApprovalSubtitle,
      retry: () => _retry(context, ref),
    );
  }
}
