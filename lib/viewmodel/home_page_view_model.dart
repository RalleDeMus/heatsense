part of heatsense;

/// View Model of the [HomePage]
class HomePageViewModel extends ChangeNotifier {
  MovesenseHRMonitor? get hrMonitor =>
      MoveSenseDeviceController().connectedDevice;

  bool running = false;

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
    // try to start the data collection.
    try {
      if (hrMonitor?.state == DeviceState.connected) {
        hrMonitor?.startTemp();

        hrMonitor?.startHR();

        hrMonitor?.startECG();

        hrMonitor?.state = DeviceState.sampling;

        // initialize storage
        Storage().init();
        Storage().setDeviceAndStartUpload(hrMonitor!);
        //print('>>> start initialized');
      } else if (hrMonitor?.state == DeviceState.sampling) {
        hrMonitor?.resumeTemp();

        hrMonitor?.resumeHR();

        hrMonitor?.resumeECG();
        //print('>>> resumed');
      }

      running = true;
      notifyListeners();
// print error if error occurs.
    } on Exception catch (e) {
      debugPrint('Start of data collection failed: $e');
      hrMonitor?.state = DeviceState.error;
    }
  }

  /// Pauses the data shown on the homepage.
  void stop() {
    // try to pause data collection
    try {
      hrMonitor?.pauseTemp();
      hrMonitor?.pauseHR();
      hrMonitor?.pauseECG();
      Storage().dump();

      running = false;
      notifyListeners();
      //print('>>> paused');
      // catch error
    } on Exception catch (e) {
      debugPrint('Stop of data collection failed: $e');
      hrMonitor?.state = DeviceState.error;
    }
  }
}
