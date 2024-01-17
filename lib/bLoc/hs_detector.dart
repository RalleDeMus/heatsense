part of heatsense;

abstract interface class HSDetector {
  //Stream<HSEvent> get detectedEvents;

  void start();
  void stop();
}

class TimerHSDetector extends ChangeNotifier implements HSDetector {
  static final TimerHSDetector _instance = TimerHSDetector._();
  TimerHSDetector._();
  factory TimerHSDetector() => _instance;

  bool e = false;

  HSEventList list = HSEventList();

  /* StreamSubscription<dynamic>? _eventSubscription;

  final _eventController = StreamController<HSEvent>.broadcast();

  @override
  Stream<HSEvent> get detectedEvents => _eventController.stream;

  
  */
  void addHSEvent(HSEvent event) {
    list.events.add(event);
    notifyListeners();
  }

  @override
  void start() {
    if (!e) {
      addHSEvent(event1);
      e = true;
    } else {
      addHSEvent(event2);
      e = false;
    }

    /*  Timer(const Duration(seconds: 10), () {
      addHSEvent(event1);
    });
    Timer(const Duration(seconds: 10), () {
      addHSEvent(event2);
    }); */
  }

  @override
  void stop() {}

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
}
