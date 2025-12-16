import 'dart:convert';
import 'dart:io';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/base_wait_approval_page.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/core/db/entities/content_entity.dart';
import 'package:academy_2_app/core/db/isar_service.dart';
import 'package:academy_2_app/core/services/certificate_service.dart';
import 'package:academy_2_app/core/services/quiz_sync_service.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.moduleId});

  final String moduleId;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<ContentEntity?> _quizFuture;
  late List<_QuizQuestion> _questions;
  final Map<String, Set<String>> _selected = {};
  int _current = 0;
  String? _quizContentId;

  @override
  void initState() {
    super.initState();
    _quizFuture = _loadQuiz();
  }

  Future<ContentEntity?> _loadQuiz() async {
    final isar = IsarService();
    final contents = await isar.getContentsByModuleId(widget.moduleId);
    return contents.firstWhere(
      (c) => c.type == 'quiz',
      orElse: () => ContentEntity()..id = '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<ContentEntity?>(
      future: _quizFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _buildScaffold(
            context,
            Center(
              child: CircularProgressWidget(),
            ),
          );
        }
        final content = snap.data;
        if (content == null || content.id.isEmpty) {
          return _buildScaffold(
            context,
            Center(child: Text(l10n.noContent)),
          );
        }
        _quizContentId = content.id;

        _questions = _parseQuestions(content.payloadJson);
        if (_questions.isEmpty) {
          return _buildScaffold(
            context,
            Center(child: Text(l10n.noContent)),
          );
        }

        final question = _questions[_current];
        final progress = '${_current + 1}/${_questions.length}';
        final canProceed = (_selected[question.id]?.isNotEmpty ?? false);

        return _buildScaffold(
          context,
          BasePageWithToolbar(
            title: content.title,
            rightIcon: Text(
              progress,
              style: AppTextStyles.b1(context)
                  .copyWith(color: AppColors.contentSecondary(context)),
            ),
            stickChildrenToBottom: true,
            isOneToolbarRow: true,
            showBackButton: true,
            paddingBottom: 57.h,
            children: [
              SizedBox(height: 16.h),
              Text(
                question.text,
                style: AppTextStyles.h2(context),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final opt = question.options[index];
                    final selected =
                        _selected[question.id]?.contains(opt.id) ?? false;
                    return _OptionCard(
                      option: opt,
                      selected: selected,
                      onTap: () => _onSelect(question, opt),
                      multiple: question.isMultiple,
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
              ActionButtonWidget(
                onPressed: canProceed ? () => _next() : null,
                loading: canProceed && false,
                text: _current == _questions.length - 1
                    ? l10n.quizTitle
                    : l10n.next,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    Widget body,
  ) {
    return Scaffold(
      body: body,
    );
  }

  void _onSelect(_QuizQuestion question, _QuizOption opt) {
    setState(() {
      final current = _selected[question.id] ?? <String>{};
      if (question.isMultiple) {
        if (current.contains(opt.id)) {
          current.remove(opt.id);
        } else {
          current.add(opt.id);
        }
      } else {
        current
          ..clear()
          ..add(opt.id);
      }
      _selected[question.id] = current;
    });
  }

  Future<void> _next() async {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
      });
      return;
    }

    final score = _calculateScore();
    final total = _questions.fold<int>(0, (sum, q) => sum + q.points);
    await _showResult(score, total);
  }

  int _calculateScore() {
    var total = 0;
    for (final q in _questions) {
      final selected = _selected[q.id] ?? {};
      if (selected.isEmpty) continue;
      final correct = q.correct.toSet();
      if (selected.length == correct.length &&
          selected.every((id) => correct.contains(id))) {
        total += q.points;
      }
    }
    return total;
  }

  Future<void> _showResult(int score, int totalPoints) async {
    if (totalPoints > 0) {
      final percent = (score / totalPoints) * 100;
      if (percent >= 80 && _quizContentId != null) {
        final isar = IsarService();
        await isar.updateQuizBestScore(_quizContentId!, score);
      }
    }

    final payload = QuizResultPayload(
      learningModuleId: widget.moduleId,
      score: score,
      details: {
        'total_points': totalPoints,
        'answers': _selected.map((k, v) => MapEntry(k, v.toList())),
      },
    );
    final response = await QuizSyncService.instance.submitResult(payload);

    if (!mounted) return;
    context.go(
      '/quiz-result',
      extra: QuizResultArgs(
        score: score,
        totalPoints: totalPoints,
        moduleId: widget.moduleId,
        certificateId: response?.id,
      ),
    );
  }

  List<_QuizQuestion> _parseQuestions(String? payloadJson) {
    if (payloadJson == null || payloadJson.isEmpty) return [];
    try {
      final map = jsonDecode(payloadJson) as Map<String, dynamic>;
      final list = map['questions'] as List<dynamic>? ?? [];
      return list.map((raw) {
        final m = raw as Map<String, dynamic>;
        final opts = (m['options'] as List<dynamic>? ?? [])
            .map((o) => _QuizOption(
                  id: o['id'] as String? ?? '',
                  text: o['text'] as String? ?? '',
                ))
            .toList();
        final correct =
            (m['correct'] as List<dynamic>? ?? []).map((e) => '$e').toList();
        final type = (m['type'] as String? ?? 'single').toLowerCase();
        return _QuizQuestion(
          id: m['id'] as String? ?? '',
          text: m['text'] as String? ?? '',
          type: type,
          points: m['points'] as int? ?? 0,
          options: opts,
          correct: correct,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}

class _QuizQuestion {
  _QuizQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.points,
    required this.options,
    required this.correct,
  });

  final String id;
  final String text;
  final String type;
  final int points;
  final List<_QuizOption> options;
  final List<String> correct;

  bool get isMultiple => type == 'multiple';
}

class _QuizOption {
  _QuizOption({required this.id, required this.text});

  final String id;
  final String text;
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
    required this.multiple,
  });

  final _QuizOption option;
  final bool selected;
  final VoidCallback onTap;
  final bool multiple;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfacePrimary(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: selected
              ? AppColors.borderFocused(context)
              : AppColors.borderPrimary(context),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.text,
                  style: AppTextStyles.b2(context).copyWith(
                    color: AppColors.contentPrimary(context),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              _SelectionIcon(selected: selected, multiple: multiple),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionIcon extends StatelessWidget {
  const _SelectionIcon({required this.selected, required this.multiple});

  final bool selected;
  final bool multiple;

  @override
  Widget build(BuildContext context) {
    if (multiple) {
      return Image.asset(
        selected
            ? 'assets/images/ic_checkbox_checked.png'
            : 'assets/images/ic_checkbox_unchecked.png',
        width: 24.w,
        height: 24.w,
      );
    }
    return Image.asset(
      selected
          ? 'assets/images/ic_radiobutton_checked.png'
          : 'assets/images/ic_radiobutton_unchecked.png',
      width: 24.w,
      height: 24.w,
    );
  }
}

class QuizResultArgs {
  const QuizResultArgs({
    required this.score,
    required this.totalPoints,
    required this.moduleId,
    this.certificateId,
  });

  final int score;
  final int totalPoints;
  final String moduleId;
  final String? certificateId;
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.args});

  final QuizResultArgs args;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? title;

  String? subtitle;

  String? body;
  bool _downloading = false;

  Future<String?> _resolveCertificateId() async {
    if (widget.args.certificateId?.isNotEmpty == true) {
      return widget.args.certificateId;
    }
    if (widget.args.moduleId.isEmpty) return null;
    final results = await QuizSyncService.instance.fetchQuizResults();
    for (final item in results) {
      if (item.learningModuleId == widget.args.moduleId && item.id.isNotEmpty) {
        return item.id;
      }
    }
    return null;
  }

  Future<void> _downloadCertificate(BuildContext context) async {
    if (_downloading) return;

    final permissionStatus = await _requestPermission(context);
    if (!permissionStatus.isGranted) {
      _handlePermissionDenied(permissionStatus, context);
      return;
    }

    setState(() => _downloading = true);
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final certificateId = await _resolveCertificateId();
      if (certificateId == null || certificateId.isEmpty) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.quizResultDownloadMissing)),
        );
        return;
      }
      final file =
          await CertificateService().downloadCertificate(certificateId);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.quizResultDownloadSuccess(file.path))),
      );
    } on CertificateDownloadException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.quizResultDownloadFailed(e.message))),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.quizResultDownloadFailed(e.toString()))),
      );
    } finally {
      if (mounted) {
        setState(() => _downloading = false);
      }
    }
  }

  Future<PermissionStatus> _requestPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final storage = await Permission.storage.request();
      if (storage.isGranted) return storage;
      final media = await Permission.photos.request();
      return media.isGranted ? media : storage;
    } else if (Platform.isIOS) {
      return Permission.photosAddOnly.request();
    }
    return PermissionStatus.granted;
  }

  void _handlePermissionDenied(
    PermissionStatus status,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final isPermanent = status.isPermanentlyDenied || status.isRestricted;
    final message = isPermanent
        ? l10n.quizResultDownloadPermissionPermanentlyDenied
        : l10n.quizResultDownloadPermissionDenied;
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        action: isPermanent
            ? SnackBarAction(
                label: l10n.quizResultDownloadOpenSettings,
                onPressed: openAppSettings,
              )
            : null,
      ),
    );
  }

  void _calculateInterest(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percentage = widget.args.totalPoints == 0
        ? 0
        : (widget.args.score / widget.args.totalPoints) * 100;
    if (percentage >= 80) {
      title = l10n.quizResultCongratsTitle;
      subtitle =
          l10n.quizResultScore(widget.args.score, widget.args.totalPoints);
      body = l10n.quizResultCongratsBody;
    } else {
      title = l10n.quizResultTryTitle;
      subtitle =
          l10n.quizResultScore(widget.args.score, widget.args.totalPoints);
      body = l10n.quizResultTryBody;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _calculateInterest(context);
    return WillPopScope(
      onWillPop: () async {
        context.go('/home');
        return false;
      },
      child: BaseWaitApprovalPage(
        title: title ?? '',
        subtitle: subtitle ?? '',
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            body ?? '',
            style: AppTextStyles.b1(context).copyWith(
              color: AppColors.contentOnAccentSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        footer: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionTextButtonWidget(
              text: l10n.quizResultSkip,
              onPressed: () => context.go('/home'),
            ),
            ActionButtonWidget(
              text: l10n.quizResultDownload,
              loading: _downloading,
              onPressed: () => _downloadCertificate(context),
            ),
          ],
        ),
      ),
    );
  }
}
