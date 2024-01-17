part of heatsense;

/// View model of the heatstroke events.
class HSEventViewModel extends ChangeNotifier {
  HSEvent hsevent;
  HSEventViewModel(this.hsevent);

  /// Getting the temperature from the event.
  List<double> get temperature {
    return hsevent.temperature;
  }

  /// Getting the heartrate from the event.
  List<int> get heartrate {
    return hsevent.heartrate;
  }

  /// Getting the ECG signal from the event.
  List<List<dynamic>> get ecg {
    return hsevent.ecgsignal;
  }

  /// Adding symptoms to the event.
  addSymptom(String symptom) {
    hsevent.symptoms.add(symptom);
    notifyListeners();
  }
}

/// The view model for the event page.
class EventPageViewModel {
  HSEventList eventList;
  EventPageViewModel(this.eventList);
}
