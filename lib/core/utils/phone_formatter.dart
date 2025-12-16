import 'package:flutter/services.dart';

class PlPhoneFormatter {
  PlPhoneFormatter._();

  static final _polandConfig = _PhoneFormatConfig('48', [3, 3, 3]);
  static final _ukraineConfig = _PhoneFormatConfig('380', [2, 3, 2, 2]);

  static String format(String input, {String? previousValue}) {
    var digits = input.replaceAll(RegExp(r'\D'), '');

    final prevDigits =
        previousValue?.replaceAll(RegExp(r'\D'), '') ?? '';
    final isDeleting =
        previousValue != null && previousValue.length > input.length;

    if (isDeleting) {
      digits = _handleDeletion(digits, prevDigits);
    }

    if (digits.isEmpty) {
      return '';
    }

    final config = _isUkrainian(digits) ? _ukraineConfig : _polandConfig;
    var localDigits = _stripCountryCode(digits, config);

    if (localDigits.isEmpty) {
      return '';
    }

    if (localDigits.length > config.maxLocalDigits) {
      localDigits = localDigits.substring(0, config.maxLocalDigits);
    }

    final buffer = StringBuffer('+${config.countryCode} ');
    final boundaries = config.groupBoundaries;
    var digitsProcessed = 0;
    var boundaryIndex = 0;

    for (var i = 0; i < localDigits.length; i++) {
      buffer.write(localDigits[i]);
      digitsProcessed++;
      if (boundaryIndex < boundaries.length &&
          digitsProcessed == boundaries[boundaryIndex] &&
          digitsProcessed < localDigits.length) {
        buffer.write(' ');
        boundaryIndex++;
      }
    }

    return buffer.toString();
  }

  static bool isValid(String text) {
    final polish = RegExp(r'^\+48 [0-9]{3} [0-9]{3} [0-9]{3}$');
    final ukrainian = RegExp(r'^\+380 [0-9]{2} [0-9]{3} [0-9]{2} [0-9]{2}$');
    return polish.hasMatch(text) || ukrainian.hasMatch(text);
  }

  static bool _isUkrainian(String digits) => digits.startsWith('38');

  static String _stripCountryCode(String digits, _PhoneFormatConfig config) {
    return digits.startsWith(config.countryCode)
        ? digits.substring(config.countryCode.length)
        : digits;
  }

  static String _handleDeletion(String digits, String prevDigits) {
    const prefixes = ['48', '380'];

    for (final prefix in prefixes) {
      if (prevDigits.startsWith(prefix)) {
        final withoutPrefix = prevDigits.substring(prefix.length);
        if (withoutPrefix == digits && digits.isNotEmpty) {
          return digits.substring(0, digits.length - 1);
        }
      }
    }

    if (prevDigits == digits && digits.isNotEmpty) {
      return digits.substring(0, digits.length - 1);
    }

    return digits;
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

class _PhoneFormatConfig {
  final String countryCode;
  final List<int> groupSizes;

  const _PhoneFormatConfig(this.countryCode, this.groupSizes);

  int get maxLocalDigits =>
      groupSizes.fold(0, (previous, size) => previous + size);

  List<int> get groupBoundaries {
    var sum = 0;
    final boundaries = <int>[];
    for (final size in groupSizes) {
      sum += size;
      boundaries.add(sum);
    }
    return boundaries;
  }
}
