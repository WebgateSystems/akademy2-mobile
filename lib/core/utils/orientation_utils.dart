import 'package:flutter/services.dart';

class OrientationUtils {
  static const List<DeviceOrientation> portraitUpOnly = [
    DeviceOrientation.portraitUp,
  ];

  static const List<DeviceOrientation> videoOrientations = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  static Future<void> lockPortrait() =>
      SystemChrome.setPreferredOrientations(portraitUpOnly);

  static Future<void> allowVideoOrientations() =>
      SystemChrome.setPreferredOrientations(videoOrientations);
}
