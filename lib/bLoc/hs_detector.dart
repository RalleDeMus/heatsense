part of heatsense;

abstract interface class HSDetector {
  //Stream<HSEvent> get detectedEvents;

  void start();
  void stop();
}

class TimerHSDetector implements HSDetector {
  static final TimerHSDetector _instance = TimerHSDetector._();
  TimerHSDetector._();
  factory TimerHSDetector() => _instance;

  HSEventList list = HSEventList();

  /* StreamSubscription<dynamic>? _eventSubscription;

  final _eventController = StreamController<HSEvent>.broadcast();

  @override
  Stream<HSEvent> get detectedEvents => _eventController.stream;
  */

  @override
  void start() {
    /* _eventSubscription?.resume(); */
  }

  @override
  void stop() {}

  //
}

class TestHSDetector extends ChangeNotifier {
  static final TestHSDetector _instance = TestHSDetector._();
  TestHSDetector._();
  factory TestHSDetector() => _instance;

  HSEvent event1 = HSEvent([
    80,
    90,
    100,
  ], [
    38,
    39,
    40,
  ], [
    [-10, 20, -3, 4],
    [1, 2, 3, 4, 5]
  ]);
  HSEvent event2 = HSEvent([
    70,
    80,
    90
  ], [
    38,
    39,
    40
  ], [
    [-10, 20, -3, 4],
    [1, 2, 3, 4, 5]
  ]);

  void addHSEvent(HSEvent event) {
    TimerHSDetector().list.add(event);
    notifyListeners();
  }

  void start() {
    Timer(const Duration(seconds: 10), () {
      addHSEvent(event1);
    });
    Timer(const Duration(seconds: 10), () {
      addHSEvent(event2);
    });
  }
}
