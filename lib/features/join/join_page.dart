import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.joinTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.joinTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(l10n.inviteToken(token)),
            ],
          ),
        ),
      ),
    );
  }
}
