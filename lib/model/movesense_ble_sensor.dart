part of heatsense;

abstract class MoveSenseBLESensor implements BLESensor {
  StreamSubscription<dynamic>? _hrSubscription;
  StreamSubscription<dynamic>? _tempSubscription;

  // The follow code controls the state management and stream of state changes.
  final _hrController = StreamController<int>.broadcast();
  final _tempController = StreamController<String>.broadcast();

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
  Stream<int> get heartbeat => _hrController.stream;

  @override
  Stream<String> get temperature => _tempController.stream;

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
  void pauseHR() => _hrSubscription?.pause();

  /// Resume collection of HR data.
  void resumeHR() => _hrSubscription?.resume();

  @override
  void stopHR() {
    _hrSubscription?.cancel();
    state = DeviceState.connected;
  }

  void pauseTemp() => _tempSubscription?.pause();

  /// Resume collection of HR data.
  void resumeTemp() => _tempSubscription?.resume();

  @override
  void stopTemp() {
    _tempSubscription?.cancel();
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
  void startHR() {
    if (state == DeviceState.connected && _serial != null) {
      _hrSubscription = MdsAsync.subscribe(
              Mds.createSubscriptionUri(_serial!, "/Meas/HR"), "{}")
          .listen((event) {
        print('>> $event');
        num hr = event["Body"]["average"];
        _hrController.add(hr.toInt());
      });
      state = DeviceState.sampling;
    }
  }

  @override
  void startTemp() async {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (state == DeviceState.connected && _serial != null) {
        MdsAsync.get(Mds.createRequestUri(_serial!, "/Meas/Temp"), "{}")
            .then((value) {
          double kelvin = value["Measurement"];
          double temperatureVal = kelvin - 273.15;
          String temp = temperatureVal.toStringAsPrecision(3);
          _tempController.add(temp);
          print(">>> $temp");
        });
      }
    });
  }
  /*if (state == DeviceState.connected && _serial != null) {
      _tempSubscription = MdsAsync.subscribe(
              Mds.createSubscriptionUri(_serial!, "/Meas/Temp"), "{}")
          .listen((event) {
        print('>>> $event');
        num temp = event["Body"]["Measurement"];
        _tempController.add(temp.toInt());
      });
      state = DeviceState.sampling;
    
      }
    */

  /// Disconnect from the Movesense device.
  void disconnect() => Mds.disconnect(address);
}
