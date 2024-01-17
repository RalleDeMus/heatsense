part of heatsense;

class HomePageViewModel extends ChangeNotifier {
  MovesenseHRMonitor? get hrMonitor =>
      MoveSenseDeviceController().connectedDevice;

  bool isStarted = false;

  bool get running => hrMonitor?.isRunning ?? false;

  //Streams of data needed on the homepage
  Stream<DeviceState> get stateChange =>
      hrMonitor?.stateChange ?? const Stream.empty();

  Stream<int> get hr => hrMonitor?.heartbeat ?? const Stream.empty();

  Stream<double> get temp => hrMonitor?.temperature ?? const Stream.empty();

  Stream<List<dynamic>> get ecg => hrMonitor?.ecg ?? const Stream.empty();

  HomePageViewModel() {
    MoveSenseDeviceController().addListener(() {
      notifyListeners();
    });
  }

  /// Starts showing the data on the homepage and initializes storage.
  void start() {
    //if (hrMonitor?.state == DeviceState.connected ||
    //  hrMonitor?.state == DeviceState.sampling) {
    if (hrMonitor?.state == DeviceState.connected) {
      hrMonitor?.startTemp();

      hrMonitor?.startHR();

      hrMonitor?.startECG();

      hrMonitor?.state = DeviceState.sampling;

      Storage().init();
      Storage().setDeviceAndStartUpload(hrMonitor!);

      isStarted = true;
    } else if (hrMonitor?.state == DeviceState.sampling) {
      hrMonitor?.resumeTemp();

      hrMonitor?.resumeHR();

      hrMonitor?.resumeECG();
    }
    notifyListeners();
    // }
  }

  /// Pauses the data shown on the homepage.
  void stop() {
    //hrMonitor?.disconnect();
    hrMonitor?.pauseTemp();
    hrMonitor?.pauseHR();
    hrMonitor?.pauseECG();
    Storage().dump();
    notifyListeners();
  }
}
