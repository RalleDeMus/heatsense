part of heatsense;

/// An interface for a device controller, which manages devices.
abstract interface class DeviceController {
  /// A list of devices.
  List<MovesenseHRMonitor> get devices;

  bool get isScanning;

  void scan();
}

// Singleton devicecontroller for handling the scan for devices
class MoveSenseDeviceController extends ChangeNotifier
    implements DeviceController {
// make class singleton
  static final MoveSenseDeviceController _instance =
      MoveSenseDeviceController._();
  MoveSenseDeviceController._();
  factory MoveSenseDeviceController() => _instance;

  String? _serial;
  bool _isScanning = false;

  final List<MovesenseHRMonitor> _devices = [];

  /// The device that the user has selected to connect to. Null if not yet selected.
  MovesenseHRMonitor? connectedDevice;

  /// Saves the connected device in the devicecontroller and connects to it.
  Future<void> setConnectedDeviceAndConnect(MovesenseHRMonitor device) async {
    connectedDevice = device;
    notifyListeners();
    await connectedDevice?.connect();
  }

  String? get serial => _serial;

  @override
  bool get isScanning => _isScanning;

  @override
  List<MovesenseHRMonitor> get devices => _devices;

  /// Checks if the permissions to use bluetooth are granted.
  Future<bool> get hasPermissions async =>
      await Permission.bluetoothScan.isGranted &&
      await Permission.bluetoothConnect.isGranted;

  /// Request the required Bluetooth permissions.
  Future<void> requestPermissions() async => await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

  /// Checks if the required permissions are granted, if not requests the required permissions.
  Future<void> init() async {
    if (!(await hasPermissions)) await requestPermissions();
  }

  @override

  /// Scans for devices to connect to.
  void scan() async {
    _devices.clear();

    await init();
    try {
      _isScanning = true;
      List<String> devicesadd = [];
      Timer(const Duration(seconds: 60), () => stopScan());
      Mds.startScan((name, address) {
        MovesenseHRMonitor device = MovesenseHRMonitor(address, name);
        print('Device found, address: $address');
        if (!devicesadd.contains(device.address)) {
          _devices.add(device);
          devicesadd.add(device.address);
          notifyListeners();
        }
      });
    } on Error {
      print('Error during scanning');
    }
  }

  /// Stops the scanning from devices.
  void stopScan() {
    _isScanning = false;
    Mds.stopScan();
  }
}
