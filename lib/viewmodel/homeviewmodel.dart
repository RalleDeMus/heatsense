part of heatsense;

class HomePageViewModel extends ChangeNotifier {
  MovesenseHRMonitor? get hrMonitor =>
      MoveSenseDeviceController().connectedDevice;

  bool get running => hrMonitor?.isRunning ?? false;

  Stream<DeviceState> get state =>
      hrMonitor?.stateChange ?? const Stream.empty();

  Stream<int> get hr => hrMonitor?.heartbeat ?? const Stream.empty();

  Stream<String> get temp => hrMonitor?.temperature ?? const Stream.empty();

  Stream<List<dynamic>> get ecg => hrMonitor?.ecg ?? const Stream.empty();

HomePageViewModel() {
  MoveSenseDeviceController().addListener(() { notifyListeners();});
}

  void start() {
    hrMonitor?.state = DeviceState.sampling;
    notifyListeners();

    hrMonitor?.startTemp();

    hrMonitor?.startHR();

    hrMonitor?.startECG();

    

    Storage().init();
    Storage().setDeviceAndStartUpload(hrMonitor!);

    notifyListeners();
  }

  void stop() {
    //hrMonitor?.disconnect();
    hrMonitor?.stopTemp();
    hrMonitor?.stopHR();
    hrMonitor?.stopECG();

    hrMonitor?.state = DeviceState.disconnected;
    notifyListeners();
  }
}
