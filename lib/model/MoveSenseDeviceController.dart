part of heatsense;

// Singleton devicecontroller for handling the scan for devices
class MoveSenseDeviceController extends ChangeNotifier implements DeviceController {
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

  void setConnectedDeviceByIndex(int index) => connectedDevice = devices[index];

  Future<void> setConnectedDeviceAndConnect(MovesenseHRMonitor device) async {
    connectedDevice = device;
    await connectedDevice?.connect();
  }

  String? get serial => _serial;

  @override
  bool get isScanning => _isScanning;

  /* 
  final StreamController<DeviceState> _stateChangeController =
      StreamController.broadcast();

  DeviceState _state = DeviceState.unknown;
 
  set state(DeviceState state) {
    _state = state;
    _stateChangeController.add(state);
  }
  
  @override
  DeviceState get state => _state;

  @override
  Stream<DeviceState> get stateChange => _stateChangeController.stream;
  */
  @override
  List<MovesenseHRMonitor> get devices => _devices;

  //asks for permission to use bluetooth
  Future<bool> get hasPermissions async =>
      await Permission.bluetoothScan.isGranted &&
      await Permission.bluetoothConnect.isGranted;

  /// Request the required Bluetooth permissions.
  Future<void> requestPermissions() async => await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

  Future<void> init() async {
    if (!(await hasPermissions)) await requestPermissions();
  }

  @override
  //The app uses this method to connect to a selected device.
  void scan() async {
    _devices.clear();
    //notifyListeners();

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

  void stopScan() {
    _isScanning = false;
    Mds.stopScan();
  }
}
