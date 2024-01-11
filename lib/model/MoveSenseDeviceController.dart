part of heatsense;

class MoveSenseDeviceController implements DeviceControler {
  final List<MovesenseHRMonitor> _devices = [];
  bool _isScanning = false;

  @override
  List<MovesenseHRMonitor> get devices => _devices;

  @override
  bool get isScanning => _isScanning;

  @override
  void scan() {
    try {
      _isScanning = true;
      Timer(const Duration(seconds: 60), () => stopScan());
      Mds.startScan((name, address) {
        var device = MovesenseHRMonitor(address, name);
        print('Device found, address: $address');
        if (!devices.contains(device)) {
          devices.add(device);
        }
      });
    } on Error {
      print('Error during scanning');
    }
  }

  void stopScan() {
    _isScanning = false;
    Mds.stopScan();
  }
}
