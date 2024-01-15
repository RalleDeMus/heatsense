part of heatsense;

class HomePageViewModel extends ChangeNotifier {
  MovesenseHRMonitor? get hrMonitor =>
      MoveSenseDeviceController().connectedDevice;

  HomePageViewModel();

  //late ScanPageViewModel scanpage;

  bool get running => hrMonitor?.isRunning ?? false;

  Stream<DeviceState> get stateChange =>
      hrMonitor?.stateChange ?? Stream.empty();

  Stream<int> get hr => hrMonitor?.heartbeat ?? Stream.empty();

  Stream<String> get temp => hrMonitor?.temperature ?? Stream.empty();

  Stream<List<String>> get ecg => hrMonitor?.ecg ?? Stream.empty();

  void startTemp() {
    hrMonitor?.startTemp();
    notifyListeners();
  }

  void startECGHR() {
    hrMonitor?.startHR();
    hrMonitor?.startECG();
    notifyListeners();
  }
}
