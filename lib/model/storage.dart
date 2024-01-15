part of heatsense;

/// Responsible for storing HR event to a Sembast database.
class Storage {
  MovesenseHRMonitor sensor;
  StoreRef? store;
  var database;

  /// Initialize this storage by identifying which [sensor] is should save
  /// data for.
  Storage(this.sensor);

  /// Initialize the storage by opening the database and listening to HR events.
  Future<void> init() async {
    print('Initializing storage, id: ${sensor.address}');

    // Get the application documents directory
    var dir = await getApplicationDocumentsDirectory();
    // Make sure it exists
    await dir.create(recursive: true);
    // Build the database path

    var path = join(dir.path, 'hr_monitor.db');

    // Delete the existing database file if it exists
    var dbFile = File(path);
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
    // Open the database
    database = await databaseFactoryIo.openDatabase(path);

    // Create a store with the name of the identifier of the monitor and which
    // can hold maps indexed by an int.
    store = intMapStoreFactory.store(sensor.address);

    // Create a JSON object with the timestamp and HR:
    //   {timestamp: 1699880580494, hr: 57}
    Map<String, int> json = {};

    // Listen to the monitor's HR event and add them to the store.
    sensor.heartbeat.listen((int hr) {
      // Timestamp the HR reading.
      json['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      json['hr'] = hr;

      // Add the json record to the database
      store?.add(database, json);
      print(json);
    });
  }

  /// The total number of HR samples collected in the database.
  ///
  /// Example use:
  ///    count().then((count) => print('>> size: $count'));
  ///
  /// Returns -1 if unknown.
  Future<int> count() async => await store?.count(database) ?? -1;
}
