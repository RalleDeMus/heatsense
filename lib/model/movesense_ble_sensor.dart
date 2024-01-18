part of heatsense;

abstract class MoveSenseBLESensor implements BLESensor {
  StreamSubscription<dynamic>? _hrSubscription;
  StreamSubscription<dynamic>? _tempSubscription;
  StreamSubscription<dynamic>? _ecgSubscription;

  /// Controller of the heartrate data.
  final _hrController = StreamController<int>.broadcast();

  /// Controller of the temperature data.
  final _tempController = StreamController<double>.broadcast();

  /// Controller of the temperature data.
  final _ecgController = StreamController<List<dynamic>>.broadcast();

  final _stateChangeController = StreamController<DeviceState>.broadcast();

  @override
  Stream<int> get heartbeat => _hrController.stream;

  @override
  Stream<double> get temperature => _tempController.stream;

  @override
  Stream<List<dynamic>> get ecg => _ecgController.stream;

  @override
  Stream<DeviceState> get stateChange => _stateChangeController.stream;

  @override
  bool get isRunning => state == DeviceState.sampling;

  /// Pause collection of HR data.
  void pauseHR() => _hrSubscription?.pause();

  /// Resume collection of HR data.
  void resumeHR() => _hrSubscription?.resume();

  /// Stop collection of HR data.
  @override
  void stopHR() {
    _hrSubscription?.cancel();
  }

  /// Pause collection of temperature data.
  void pauseTemp() => _tempSubscription?.pause();

  /// Resume collection of temperature data.
  void resumeTemp() => _tempSubscription?.resume();

  /// Stop collection of temperature data.
  @override
  void stopTemp() {
    _tempSubscription?.cancel();
  }

  /// Pause collection of ECG data.
  void pauseECG() => _ecgSubscription?.pause();

  /// Resume collection of ECG data.
  void resumeECG() => _ecgSubscription?.resume();

  /// Stop collection of ECG data.
  @override
  void stopECG() {
    _ecgSubscription?.cancel();
  }
}

/// A class that contains all the attributes of the MoveSense device.
class MovesenseHRMonitor extends MoveSenseBLESensor {
  String? _address, _name, _serial;

  @override
  String? get identifier => _address;

  @override
  DeviceState get state => _state;

  /// The BLE address of the device.
  String get address => _address!;

  /// The name of the device.
  String? get serial => _serial;

  /// The serial number of the device.
  String? get name => _name;

  MovesenseHRMonitor(this._address, [this._name]);

  DeviceState _state = DeviceState.unknown;

  /// Sets the updated state and adds the new state to the controller.
  set state(DeviceState state) {
    _state = state;
    _stateChangeController.add(state);
    //print('%% state change: $state');
  }

  /// Start connecting to the MoveSense device with the specified address.
  Future<void> connect() async {
    state = DeviceState.initialized;

    // try to connect to device
    try {
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
      // Throw DeviceException if an error occurs.
    } on Exception catch (e) {
      state = DeviceState.error;
      throw DeviceException(
          'Error during connect to device - error: $e', address);
    }
  }

  /// Method for listening to heartrate data. The data is fed into a stream that can be listened to.
  @override
  void startHR() {
    if (_serial != null) {
      _hrSubscription = MdsAsync.subscribe(
              Mds.createSubscriptionUri(_serial!, "/Meas/HR"), "{}")
          .listen((event) {
        num hr = event["Body"]["average"];
        //print('>> $hr');
        _hrController.add(hr.toInt());
      });
    }
  }

  /// Method for listening to temperature data. The data is fed into a stream that can be listened to.
  @override
  void startTemp() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_serial != null) {
        MdsAsync.get(Mds.createRequestUri(_serial!, "/Meas/Temp"), "{}")
            .then((value) {
          double kelvin = value["Measurement"];
          double temp = double.parse((kelvin - 273.15).toStringAsFixed(1));
          _tempController.add(temp);
          //print(">>> $temp");
        });
      }
    });
  }

  /// Method for listening to ECG data. The data is fed into a stream that can be listened to.
  @override
  void startECG() {
    if (_serial != null) {
      _ecgSubscription = MdsAsync.subscribe(
              Mds.createSubscriptionUri(_serial!, "/Meas/ECG/125"), "{}")
          .listen((event) {
        //print('>> $event');
        List<dynamic> ecg = event["Body"]["Samples"];
        _ecgController.add(ecg);
      });
    }
  }

  /// Disconnect from MoveSense Device.
  void disconnect() => Mds.disconnect(address);
}

/// An exception for devices.
///
/// To be used in try ... catch
class DeviceException implements Exception {
  String message;
  String address;

  DeviceException(this.message, this.address);

  @override
  String toString() => '$runtimeType - $message, device address: $address';
}
