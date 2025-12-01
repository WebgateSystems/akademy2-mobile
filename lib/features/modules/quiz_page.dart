import 'dart:convert';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/core/db/entities/content_entity.dart';
import 'package:academy_2_app/core/db/isar_service.dart';
import 'package:academy_2_app/features/modules/content_pages.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final content = snap.data;
        if (content == null || content.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.quizTitle)),
            body: Center(child: Text(l10n.noContent)),
          );
        }

        _questions = _parseQuestions(content.payloadJson);
        if (_questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.quizTitle)),
            body: Center(child: Text(l10n.noContent)),
          );
        }

        final question = _questions[_current];
        final progress = '${_current + 1}/${_questions.length}';
        final canProceed = (_selected[question.id]?.isNotEmpty ?? false);

        return Scaffold(
          appBar: AppBar(
            title: Text('${content.title} ($progress)'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.text,
                  style: AppTextStyles.h4(context),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canProceed ? _next : null,
                    child: Text(
                      _current == _questions.length - 1
                          ? l10n.quizTitle
                          : l10n.next,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
      });
      return;
    }

    final score = _calculateScore();
    _showResult(score);
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

  void _showResult(int score) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 12.h),
                      Text(
                        'Gratulacje!',
                        style: AppTextStyles.h3(context),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Zdobyłeś $score pkt w quizie!',
                        style: AppTextStyles.h5(context),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Świetna robota — możesz teraz pobrać swój certyfikat i pochwalić się swoim wynikiem! 🏅',
                        style: AppTextStyles.b2(context).copyWith(
                            color: AppColors.contentSecondary(context)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Zamknij'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
      color: selected
          ? AppColors.surfaceAccent(context)
          : AppColors.surfacePrimary(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: selected
              ? AppColors.contentPrimary(context)
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
              _SelectionIcon(selected: selected, multiple: multiple),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  option.text,
                  style: AppTextStyles.b1(context).copyWith(
                    color: AppColors.contentPrimary(context),
                  ),
                ),
              ),
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
      return Icon(
        selected ? Icons.check_box : Icons.check_box_outline_blank,
        color: AppColors.contentPrimary(context),
      );
    }
    return Icon(
      selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: AppColors.contentPrimary(context),
    );
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.resultId});

  final String resultId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ContentPlaceholderPage(
      title: l10n.resultTitle,
      body: 'Result placeholder for $resultId',
    );
  }
}
