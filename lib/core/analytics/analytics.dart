class Analytics {
  void track(String event, [Map<String, dynamic>? props]) {
  }

  Future<void> flush() async {}
}

final analytics = Analytics();
