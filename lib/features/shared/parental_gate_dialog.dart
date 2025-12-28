import 'dart:math';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/action_outlinedbutton_widget.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParentalGateDialog extends StatefulWidget {
  const ParentalGateDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ParentalGateDialog(),
    );
    return result ?? false;
  }

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog> {
  late final TextEditingController _answerCtrl;
  late _ParentalGateChallenge _challenge;
  late Map<String, String> _wordDigits;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _answerCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final l10n = AppLocalizations.of(context)!;
    final digitWords = _digitWordsForLocale(l10n.localeName);
    _challenge = _pickChallenge(l10n, digitWords);
    _wordDigits = _wordDigitMap(digitWords);
    _initialized = true;
  }

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final normalized = _normalizeAnswer(_answerCtrl.text, _wordDigits);
    final ok = _challenge.isCorrect(normalized);
    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _hasError = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20.w),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 400.w,
        ),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surfacePrimary(context),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.parentalGateTitle,
              style: AppTextStyles.h3(context),
            ),
            SizedBox(height: 10.h),
            Text(
              l10n.parentalGateMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.b1(context).copyWith(
                color: AppColors.contentSecondary(context),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              _challenge.question,
              textAlign: TextAlign.center,
              style: AppTextStyles.b1(context),
            ),
            SizedBox(height: 12.h),
            EditTextWidget(
              label: l10n.parentalGateAnswerHint,
              hint: l10n.parentalGateAnswerHint,
              controller: _answerCtrl,
              keyboard: TextInputType.text,
              errorText: _hasError ? l10n.parentalGateError : null,
              onChanged: (_) {
                if (_hasError) setState(() => _hasError = false);
                setState(() {});
              },
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: ActionOutlinedButtonWidget(
                    height: 48.r,
                    onPressed: () => Navigator.of(context).pop(false),
                    text: l10n.parentalGateCancel,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ActionButtonWidget(
                    height: 48.r,
                    onPressed: _answerCtrl.text.trim().isEmpty ? null : _submit,
                    text: l10n.parentalGateConfirm,
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

class _ParentalGateChallenge {
  _ParentalGateChallenge.sum({
    required int a,
    required int b,
    required String questionText,
  })  : question = questionText,
        _expected = (a + b).toString();

  _ParentalGateChallenge.sequence({
    required List<int> digits,
    required String questionText,
  })  : question = questionText,
        _expected = digits.join();

  final String question;
  final String _expected;

  bool isCorrect(String normalizedAnswer) => normalizedAnswer == _expected;
}

_ParentalGateChallenge _pickChallenge(
    AppLocalizations l10n, List<String> digitWords) {
  final additions = [
    [24, 13],
    [17, 8],
    [15, 19],
    [12, 15],
  ];
  final sequences = [
    [8, 3, 0],
    [4, 1, 7],
    [9, 2, 5],
  ];

  final options = <_ParentalGateChallenge>[
    for (final pair in additions)
      _ParentalGateChallenge.sum(
        a: pair[0],
        b: pair[1],
        questionText: l10n.parentalGateQuestionSum(pair[0], pair[1]),
      ),
    for (final seq in sequences)
      _ParentalGateChallenge.sequence(
        digits: seq,
        questionText: l10n.parentalGateQuestionDigits(
          seq.map((d) => digitWords[d]).join(', '),
        ),
      ),
  ];

  return options[Random().nextInt(options.length)];
}

String _normalizeAnswer(String raw, Map<String, String> wordDigits) {
  final buffer = StringBuffer();
  final sanitized = raw.toLowerCase().replaceAll('’', '\'');
  final tokenPattern =
      RegExp(r"[0-9]+|[a-ząćęłńóśźż]+|[а-яіїєґё']+", caseSensitive: false);

  for (final match in tokenPattern.allMatches(sanitized)) {
    final token = match.group(0);
    if (token == null || token.isEmpty) continue;
    if (RegExp(r'^[0-9]+$').hasMatch(token)) {
      buffer.write(token);
      continue;
    }
    final mapped = wordDigits[token];
    if (mapped != null) buffer.write(mapped);
  }

  return buffer.toString();
}

Map<String, String> _wordDigitMap(List<String> words) {
  final map = <String, String>{};
  for (var i = 0; i < words.length; i++) {
    map[words[i].toLowerCase()] = '$i';
    map[words[i].toLowerCase().replaceAll("'", '’')] = '$i';
  }

  const englishDigits = [
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
  ];
  for (var i = 0; i < englishDigits.length; i++) {
    map.putIfAbsent(englishDigits[i], () => '$i');
  }

  return map;
}

List<String> _digitWordsForLocale(String localeName) {
  final lang = localeName.split('_').first.toLowerCase();
  switch (lang) {
    case 'uk':
      return const [
        'нуль',
        'один',
        'два',
        'три',
        'чотири',
        "п'ять",
        'шість',
        'сім',
        'вісім',
        "дев'ять",
      ];
    case 'pl':
      return const [
        'zero',
        'jeden',
        'dwa',
        'trzy',
        'cztery',
        'pięć',
        'sześć',
        'siedem',
        'osiem',
        'dziewięć',
      ];
    default:
      return const [
        'zero',
        'one',
        'two',
        'three',
        'four',
        'five',
        'six',
        'seven',
        'eight',
        'nine',
      ];
  }
}
