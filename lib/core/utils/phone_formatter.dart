import 'package:flutter/services.dart';

class PlPhoneFormatter {
  PlPhoneFormatter._();

  static String format(String input, {String? previousValue}) {
    var digits = input.replaceAll(RegExp(r'\D'), '');

    if (digits.startsWith('48')) {
      digits = digits.substring(2);
    }

    if (digits.isEmpty) {
      return '';
    }

    final isDeleting =
        previousValue != null && previousValue.length > input.length;

    if (isDeleting) {
      final prevDigits = previousValue.replaceAll(RegExp(r'\D'), '');
      if (prevDigits.startsWith('48')) {
        final prevDigitsWithout48 = prevDigits.substring(2);
        if (prevDigitsWithout48 == digits && digits.isNotEmpty) {
          digits = digits.substring(0, digits.length - 1);
        }
      } else if (prevDigits == digits && digits.isNotEmpty) {
        digits = digits.substring(0, digits.length - 1);
      }
    }

    if (digits.isEmpty) {
      return '';
    }

    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    final buffer = StringBuffer('+48 ');

    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i == 2 || i == 5) && i < digits.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  static bool isValid(String text) {
    final regex = RegExp(r'^\+48 [0-9]{3} [0-9]{3} [0-9]{3}$');
    return regex.hasMatch(text);
  }

  static String toApiFormat(String formatted) {
    return formatted.replaceAll(' ', '');
  }
}

class PlPhoneInputFormatter extends TextInputFormatter {
  String _previousValue = '';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = PlPhoneFormatter.format(
      newValue.text,
      previousValue: _previousValue,
    );
    _previousValue = formatted;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
