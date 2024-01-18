part of heatsense;

/// The heatstroke event class that holds all the information about a specific event.
class HSEvent {
  static int counter = 1;

  late DateTime timestamp;

  Duration timespan;

  late int eventId;

  List<String> symptoms = [];

  List<int> heartrate;

  List<double> temperature;

  List<List<dynamic>> ecgsignal;

  HSEvent(
    this.heartrate,
    this.temperature,
    this.ecgsignal, [
    this.timespan = const Duration(minutes: 15),
  ]) {
    timestamp = DateTime.now();
    eventId = counter++;
  }
}

/// Holds a list of heatstroke events.
class HSEventList {
  List<HSEvent> events = [];
}
