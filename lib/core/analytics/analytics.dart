class Analytics {
  // No-op analytics adapter for M1. Replace with Sentry/Firebase adapter later.
  void track(String event, [Map<String, dynamic>? props]) {
    // intentionally empty for scaffold
  }

  Future<void> flush() async {}
}

final analytics = Analytics();
