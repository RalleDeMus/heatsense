part of heatsense;

/// States that a given device can be in.
enum DeviceState {
  unknown,
  initialized,
  connecting,
  connected,
  sampling,
  disconnected,
  error,
}

/// The interface for a bluetooth ECG sensor.
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

  /// Start heartrate data collection.
  void startHR();

  /// Start temperature data collection.
  void startTemp();

  /// Start ECG data collection.
  void startECG();

  /// Stop heartrate data collection.
  void stopHR();

  /// Stop temperature data collection.
  void stopTemp();

  /// Stop ECG data collection.
  void stopECG();
}
