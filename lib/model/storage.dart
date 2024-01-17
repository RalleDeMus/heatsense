part of heatsense;

/// Responsible for storing HR event to a Sembast database.
class Storage {
  static final Storage _instance = Storage._();
  Storage._();
  factory Storage() => _instance;

  static const String DB_NAME = 'HeatSense_data';
  MovesenseHRMonitor? sensor;
  StoreRef? store;
  var database;
  var time = 0;

  /// The path to the phone's application folder.
  Directory? dir;

  /// Initialize the storage by opening the database and listening to HR events.
  Future<void> init() async {
    print('Initializing storage, id: ${sensor?.address}');

    // Get the application documents directory
    dir = await getApplicationDocumentsDirectory();

    if (dir == null) {
      print('WARNING - could not create database. Data is not saved....');
    } else {
      // Make sure it exists
      await dir!.create(recursive: true);
      // Build the database path

      var path = join(dir!.path, '${DB_NAME}.db');

      // Delete the existing database file if it exists
      var dbFile = File(path);
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
      // Open the database
      database = await databaseFactoryIo.openDatabase(path);

      // Create a store with the name of the identifier of the monitor and which
      // can hold maps indexed by an int.
      store = intMapStoreFactory.store(sensor?.address);
    }
  }

  // Create a JSON object with the timestamp and data:
  //   {timestamp: 1699880580494, hr: 57}
  Map<String, dynamic> hrJson = {};
  Map<String, dynamic> tempJson = {};
  Map<String, dynamic> ecgJson = {};

  /// Initialize this storage by identifying which [sensor] is should save
  /// data for.
  void setDeviceAndStartUpload(MovesenseHRMonitor device) {
    sensor = device;
    // Listen to the monitor's HR event and add them to the store.
    sensor?.heartbeat.listen((int hr) {
      // Timestamp the HR reading.
      hrJson['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      hrJson['hr'] = hr;

      // Add the json record to the database
      store?.add(database!, hrJson);
      print('>>>> $hrJson');
    });

    sensor?.temperature.listen((double temp) {
      // Timestamp the temp reading.
      tempJson['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      tempJson['temp'] = temp;

      // Add the json record to the database
      store?.add(database!, tempJson);
      print('>>>> $tempJson');
    });

    /* sensor?.ecg.listen((echo) {
      // Timestamp the ecg reading.
      ecgJson['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      ecgJson['ecg'] = echo;

      // Add the json record to the database
      store?.add(database!, ecgJson);
      print('>>>> $ecgJson');
    });
 */
    UploadManager uploader = UploadManager(this);
    uploader.startUpload();
  }

  /// The total number of samples collected in the database.
  ///
  /// Example use:
  ///    count().then((count) => print('>> size: $count'));
  ///
  /// Returns -1 if unknown.
  Future<int> count() async => await store?.count(database!) ?? -1;

  Future<List<RecordSnapshot<Object?, Object?>>> findJson() async {
    var finder = Finder(
        filter: Filter.greaterThan('timestamp', time),
        sortOrders: [SortOrder('timestamp')]);
    var records = await store!.find(database!, finder: finder);
    //time = DateTime.now().microsecondsSinceEpoch;
    return records;
  }

  /// Get the list of json objects which has not yet been uploaded.
  Future<List<Map<String, dynamic>>> getJsonToUpload() async {
    var finder = Finder(
        filter: Filter.greaterThan('timestamp', time),
        sortOrders: [SortOrder('timestamp')]);
    List<RecordSnapshot<Object?, Object?>> records =
        await store!.find(database!, finder: finder);
    List<Map<String, dynamic>> result = [];
    for (var record in records) {
      result.add({record.key.toString(): record.value});
    }

    return result;
  }

  void deleteDatabase() async {
    database.close();
    var dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'HeatSense_data.db');
    await databaseFactoryIo.deleteDatabase(path);
  }

  Future<void> dump() async {
    print('Starting to dump database');
    int count = await this.count();

    // Export db, but only this store.
    Map<String, Object?> data =
        await exportDatabase(database, storeNames: [sensor!.address]);

    // Convert the JSON map to a string representation.
    String dataAsJson = json.encode(data);
    // Build the file path and write the data
    var path = join(dir!.path, '$DB_NAME.json');
    await File(path).writeAsString(dataAsJson);
    print("Database dumped in file '$path'. "
        'Total $count records successfully written to file.');
  }
}

/// A manager that collects data from [storage] which has not been uploaded
/// yet and uploads this on regular basis.
class UploadManager {
  Storage storage;
  Timer? uploadTimer;

  /// Create an [UploadManager] which can upload data stored in [storage].
  UploadManager(this.storage);

  /// Start uploading every 10 minutes.
  void startUpload() {
    uploadTimer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      var dataToUpload = await storage.getJsonToUpload();
      print('Uploading ${dataToUpload.length} json objects...');
      print('>>>> $dataToUpload');
      storage.time = DateTime.now().microsecondsSinceEpoch;
      print('>>>>> ${storage.time}');
    });
  }

  /// Stop uploading.
  void stopUpload() => uploadTimer?.cancel();
}
