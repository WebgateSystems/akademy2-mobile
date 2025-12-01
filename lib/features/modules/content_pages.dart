import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class ContentPlaceholderPage extends StatelessWidget {
  const ContentPlaceholderPage({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(body, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class VideoPage extends StatelessWidget {
  const VideoPage({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ContentPlaceholderPage(
      title: l10n.videoTitle,
      body: 'Module $moduleId: ${l10n.loading}',
    );
  }
}

class InfographicPage extends StatelessWidget {
  const InfographicPage({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ContentPlaceholderPage(
      title: l10n.infographicTitle,
      body: 'Module $moduleId: ${l10n.loading}',
    );
  }
}
