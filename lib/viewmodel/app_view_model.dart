part of heatsense;

/// The main viewmodel of the app.
class AppViewModel {
  AppModel model;
  late EventPageViewModel eventList;
  late HomePageViewModel homeModel;

  AppViewModel(this.model) {
    eventList = EventPageViewModel(model.events);
    homeModel = HomePageViewModel();
  }
}
