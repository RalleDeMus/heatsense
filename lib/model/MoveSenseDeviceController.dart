part of heatsense;

class MoveSenseDeviceController extends ChangeNotifier
    implements DeviceController {
  String? _serial;
  final Set<MovesenseHRMonitor> _devices = {};
  final _devicesController = StreamController<MovesenseHRMonitor>.broadcast();

  @override
  String connectedDeviceId = "";

  Stream<MovesenseHRMonitor> get devicestream => _devicesController.stream;

  String? get serial => _serial;

  bool _isScanning = false;

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

  @override
  UnmodifiableListView<MovesenseHRMonitor> get devices =>
      UnmodifiableListView(_devices);

  @override
  bool get isScanning => _isScanning;

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
  void scan() async {
    _devices.clear();
    notifyListeners();

    await init();
    try {
      _isScanning = true;
      Timer(const Duration(seconds: 60), () => stopScan());
      Mds.startScan((name, address) {
        MovesenseHRMonitor device = MovesenseHRMonitor(address, name);
        print('Device found, address: $address');
        if (!_devices.contains(device)) {
          _devices.add(device);
          _devicesController.add(device);
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

  Future<void> connect(MovesenseHRMonitor device) async {
    state = DeviceState.initialized;
    if (!(await hasPermissions)) await requestPermissions();

    // Start connecting to the Movesense device with the specified address.
    state = DeviceState.connecting;
    Mds.connect(
      device.address,
      (serial) {
        _serial = serial;
        state = DeviceState.connected;
      },
      () => state = DeviceState.disconnected,
      () => state = DeviceState.error,
    );
  }
}
