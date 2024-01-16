part of heatsense;

class HSEvent {
  static int counter = 1;
  late DateTime timestamp;

  Duration timespan;

  late int eventId;

  List<String> symptoms = [];

  List<int> heartrate;

  List<int> temperature;

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

class HSEventList {
  List<HSEvent> events = [];
}
