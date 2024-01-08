part of heatsense;

abstract interface class BLESensor {
  String? get address;

  Stream<String> get batteryStatus;

  bool get isConnected;

  Stream<int> get heartRate;

  Stream<bool> get isActive;

  Future<bool> get hasPermissions;

  Future<void> requestPermissions();

  Future<void> connect();

  Future<void> disconnect();

  String get name;

  void start();

  void stop();
}
