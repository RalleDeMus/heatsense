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

  Stream<String> get temperature;

  /// Has this monitor been started via the [start] command?
  bool get isRunning;

  /// Initialize this HR monitor.
  Future<void> init();

  /// Start this HR monitor.
  void startHR();

  void startTemp();

  /// Stop this HR monitor.
  void stopHR();

  void stopTemp();
}

abstract interface class DeviceControler {
  List<MoveSenseBLESensor> get devices;

  bool get isScanning;

  void scan();
}
