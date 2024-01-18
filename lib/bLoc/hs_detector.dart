part of heatsense;

/// An interface for a heatstroke detector.
abstract interface class HSDetector {
  HSEventList get list;

  void start();

  void stop();
}

/// The detector that detects if a heatstroke has occured.
class TimerHSDetector extends ChangeNotifier implements HSDetector {
  static final TimerHSDetector _instance = TimerHSDetector._();
  TimerHSDetector._();
  factory TimerHSDetector() => _instance;

  bool e = false;

  @override
  HSEventList list = HSEventList();

  /// Adds a HSEvent to the list of events.
  void addHSEvent(HSEvent event) {
    list.events.add(event);
    notifyListeners();
  }

  @override
  // TODO - implement the algorithm to check for a heatstroke.
  /// Starts the heatstroke detector.
  void start() {
    if (!e) {
      addHSEvent(event1);
      e = true;
    } else {
      addHSEvent(event2);
      e = false;
    }
  }

  @override
  // TODO - implement the stop method for the detector.
  /// Stops the heatstroke detector.
  void stop() {}

  // a couple of dummy events.
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
