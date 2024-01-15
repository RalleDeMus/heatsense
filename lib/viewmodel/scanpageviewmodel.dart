part of heatsense;

class ScanPageViewModel extends ChangeNotifier {
  void scanForDevices() {
    MoveSenseDeviceController().scan();
    notifyListeners();
  }
}
