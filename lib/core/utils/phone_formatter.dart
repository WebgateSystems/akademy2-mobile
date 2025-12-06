import 'package:flutter/services.dart';

/// Utility class for Polish phone number formatting and validation
class PlPhoneFormatter {
  PlPhoneFormatter._();

  /// Formats input to Polish phone format: +48 XXX XXX XXX
  ///
  /// [input] - raw input string
  /// [previousValue] - previous text value (used to detect backspace)
  ///
  /// Returns formatted phone string or empty string if no digits
  static String format(String input, {String? previousValue}) {
    // Extract only digits
    var digits = input.replaceAll(RegExp(r'\D'), '');

    // If starts with 48, treat it as country code and remove
    if (digits.startsWith('48')) {
      digits = digits.substring(2);
    }

    // If no digits - return empty (allows full deletion)
    if (digits.isEmpty) {
      return '';
    }

    // Detect backspace: if previous value was longer and we're at a formatting boundary
    final isDeleting =
        previousValue != null && previousValue.length > input.length;

    // If deleting and current input ends with space or +48, help user delete
    if (isDeleting) {
      // Count digits in previous value
      final prevDigits = previousValue.replaceAll(RegExp(r'\D'), '');
      if (prevDigits.startsWith('48')) {
        final prevDigitsWithout48 = prevDigits.substring(2);
        // If we had same number of real digits, user is trying to delete formatting
        // Let them continue by removing one more digit
        if (prevDigitsWithout48 == digits && digits.isNotEmpty) {
          digits = digits.substring(0, digits.length - 1);
        }
      } else if (prevDigits == digits && digits.isNotEmpty) {
        // User deleted formatting char, help by removing a digit
        digits = digits.substring(0, digits.length - 1);
      }
    }

    // If all digits were removed
    if (digits.isEmpty) {
      return '';
    }

    // Max 9 digits for Polish number
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    // Build formatted string: +48 XXX XXX XXX
    final buffer = StringBuffer('+48 ');

    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      // Add space after 3rd and 6th digit (indices 2 and 5)
      if ((i == 2 || i == 5) && i < digits.length - 1) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  /// Validates if phone matches Polish format: +48 XXX XXX XXX
  static bool isValid(String text) {
    final regex = RegExp(r'^\+48 [0-9]{3} [0-9]{3} [0-9]{3}$');
    return regex.hasMatch(text);
  }

  /// Extracts clean phone number for API: +48XXXXXXXXX
  static String toApiFormat(String formatted) {
    return formatted.replaceAll(' ', '');
  }
}

/// TextInputFormatter for Polish phone numbers
/// Use this with TextField for automatic formatting
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
