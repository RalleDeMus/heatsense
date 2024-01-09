part of heatsense;

abstract class MoveSenseBLESensor implements BLESensor {
  StreamSubscription<dynamic>? _subscription;

  // The follow code controls the state management and stream of state changes.
  final _controller = StreamController<int>.broadcast();

  final StreamController<DeviceState> _stateChangeController =
      StreamController.broadcast();
  DeviceState _state = DeviceState.unknown;

  set state(DeviceState state) {
    print('The device with id $identifier is ${state.name}.');
    _state = state;
    _stateChangeController.add(state);
  }

  @override
  DeviceState get state => _state;

  @override
  Stream<DeviceState> get stateChange => _stateChangeController.stream;

  @override
  Stream<int> get heartbeat => _controller.stream;

  @override
  Future<void> init() async {
    if (!(await hasPermissions)) await requestPermissions();
  }

  Future<bool> get hasPermissions async =>
      await Permission.bluetoothScan.isGranted &&
      await Permission.bluetoothConnect.isGranted;

  /// Request the required Bluetooth permissions.
  Future<void> requestPermissions() async => await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

  @override
  bool get isRunning => state == DeviceState.sampling;

  /// Pause collection of HR data.
  void pause() => _subscription?.pause();

  /// Resume collection of HR data.
  void resume() => _subscription?.resume();

  @override
  void stop() {
    _subscription?.cancel();
    state = DeviceState.connected;
  }
}

class MovesenseHRMonitor extends MoveSenseBLESensor {
  String? _address, _name, _serial;

  @override
  String get identifier => _address!;

  /// The BLE address of the device.
  String get address => _address!;

  /// The name of the device.
  String? get serial => _serial;

  /// The serial number of the device.
  String? get name => _name;

  MovesenseHRMonitor(this._address, [this._name]);

  static List<MovesenseHRMonitor> devices = [];

  static void startScan() {
    try {
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

  @override
  Future<void> init() async {
    state = DeviceState.initialized;
    if (!(await hasPermissions)) await requestPermissions();

    // Start connecting to the Movesense device with the specified address.
    state = DeviceState.connecting;
    Mds.connect(
      address,
      (serial) {
        _serial = serial;
        state = DeviceState.connected;
      },
      () => state = DeviceState.disconnected,
      () => state = DeviceState.error,
    );
  }

  @override
  void start() {
    if (state == DeviceState.connected && _serial != null) {
      _subscription = MdsAsync.subscribe(
              Mds.createSubscriptionUri(_serial!, "/Meas/HR"), "{}")
          .listen((event) {
        print('>> $event');
        num hr = event["Body"]["average"];
        _controller.add(hr.toInt());
      });
      state = DeviceState.sampling;
    }
  }

  /// Disconnect from the Movesense device.
  void disconnect() => Mds.disconnect(address);
}
