part of heatsense;

enum DeviceState {
  unknown,
  initialized,
  connecting,
  connected,
  sampling,
  disconnected,
  error,
}

abstract class BLESensor {
  /// The identifier of this monitor.
  String? get identifier;

  /// The state of this monitor.
  DeviceState get state;

  /// The stream of state changes of this monitor.
  Stream<DeviceState> get stateChange;

  /// The stream of heartbeat measures from this HR monitor.
  Stream<int> get heartbeat;

  /// The stream of temperature measures from this HR monitor.
  Stream<double> get temperature;

  /// The stream of temperature measures from this HR monitor.
  Stream<List<dynamic>> get ecg;

  /// Has this monitor been started via the [start] command?
  bool get isRunning;

  /// Start different data collection.
  void startHR();

  void startTemp();

  void startECG();

  /// Stop different data collection.
  void stopHR();

  void stopTemp();

  void stopECG();
}

abstract interface class DeviceController {
  List<MovesenseHRMonitor> get devices;

  bool get isScanning;

  void scan();

  //DeviceState get state;

  //Stream<DeviceState> get stateChange;

  //String get connectedDeviceId;
}
