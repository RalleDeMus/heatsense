library heatsense;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:collection';
import 'dart:async';
import 'package:mdsflutter/Mds.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

part 'bLoc/hs_detector.dart';

part 'model/sensor.dart';
part 'model/movesense_ble_sensor.dart';
part 'model/MoveSenseDeviceController.dart';
part 'model/hsevent.dart';
part 'model/app_model.dart';
part 'model/storage.dart';

part 'viewmodel/eventviewmodel.dart';
part 'viewmodel/app_view_model.dart';
part 'viewmodel/scanpageviewmodel.dart';
part 'viewmodel/homeviewmodel.dart';

part 'view/heatsense_app.dart';
part 'view/EventPage.dart';
part 'view/HomePage.dart';
part 'view/ProfilePage.dart';
part 'view/ScanPage.dart';

void main() {
  runApp(HeatSenseApp());
}

class HeatSenseApp extends StatelessWidget {
  HeatSenseApp({super.key});
  final AppModel appModel = AppModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavigationBarHeatSense(model: AppViewModel(appModel)),
    );
  }
}
