part of heatsense;

class HomePageViewModel extends ChangeNotifier {
  MovesenseHRMonitor? get hrMonitor =>
      MoveSenseDeviceController().connectedDevice;

  HomePageViewModel();

  //late ScanPageViewModel scanpage;

  bool get running => hrMonitor?.isRunning ?? false;

  Stream<DeviceState> get stateChange =>
      hrMonitor?.stateChange ?? const Stream.empty();

  Stream<int> get hr => hrMonitor?.heartbeat ?? const Stream.empty();

  Stream<String> get temp => hrMonitor?.temperature ?? const Stream.empty();

  Stream<List<dynamic>> get ecg => hrMonitor?.ecg ?? const Stream.empty();

  void start() {
    hrMonitor?.startTemp();

    hrMonitor?.startHR();

    hrMonitor?.startECG();

    hrMonitor?.state = DeviceState.sampling;

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
