library heatsense;

//list of imported packages used in this project
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/utils/sembast_import_export.dart';
import 'dart:async';
import 'package:mdsflutter/Mds.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

// BLoc files
part 'bLoc/hs_detector.dart';

// model files
part 'model/sensor.dart';
part 'model/movesense_ble_sensor.dart';
part 'model/movesense_device_controller.dart';
part 'model/hsevent.dart';
part 'model/app_model.dart';
part 'model/storage.dart';

// view files
part 'view/main_page_view.dart';
part 'view/event_page_view.dart';
part 'view/home_page_view.dart';
part 'view/profile_page_view.dart';
part 'view/scan_page_view.dart';

// view model files
part 'viewmodel/event_page_view_model.dart';
part 'viewmodel/app_view_model.dart';
part 'viewmodel/home_page_view_model.dart';

void main() {
  runApp(HeatSenseApp());
}

class HeatSenseApp extends StatelessWidget {
  HeatSenseApp({super.key});
  final AppModel appModel = AppModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(model: AppViewModel(appModel)),
    );
  }
}
