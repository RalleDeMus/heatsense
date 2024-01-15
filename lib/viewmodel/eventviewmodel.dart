part of heatsense;

class HSEventViewModel extends ChangeNotifier {
  HSEvent hsevent;
  HSEventViewModel(this.hsevent);

  String get temperature {
    // TODO - pretty print w. 2 decimals
    return hsevent.temperature.toString();
  }

  addSymptom(String symptom) {
    hsevent.symptoms.add(symptom);
    notifyListeners();
  }
}

class EventPageViewModel {
  HSEventList events;
  EventPageViewModel(this.events);
}
