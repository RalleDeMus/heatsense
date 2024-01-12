# HeatSense

This project creates a flutter application that is capable of showing sensor data. A Movesense device is used to measure Hearrate and temperute. The phones GPS is used to get location data. 

### Connecting to Movesense
The phone use bluetooth to listen for devices. After listening a list of detected device(s) can be choosen.

` 
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
  `

  ### Listen to HR events
  listening to HR
  ' 
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
'
