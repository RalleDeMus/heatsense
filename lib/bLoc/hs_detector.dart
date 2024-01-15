part of heatsense;

// TODO - make singleton

abstract interface class HSDetector {
  Stream<HSEvent> get detectedEvents;

  void start();
  void stop();
}

class TimerHSDetector implements HSDetector {
  static final TimerHSDetector _instance = TimerHSDetector._();
  TimerHSDetector._();
  factory TimerHSDetector() => _instance;

  @override
  // TODO: implement detectedEvents
  Stream<HSEvent> get detectedEvents => throw UnimplementedError();

  @override
  void start() {
    // TODO: implement start
  }

  @override
  void stop() {
    // TODO: implement stop
  }

  // HSEventList list;
}

class TestHSDetector {}
