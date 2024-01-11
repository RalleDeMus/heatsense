library heatsense;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:collection';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:mdsflutter/Mds.dart';

part 'model/sensor.dart';
part 'model/movesense_ble_sensor.dart';
part 'view/heatsense_app.dart';
part 'view/EventPage.dart';
part 'view/HomePage.dart';
part 'view/ProfilePage.dart';
part 'model/MoveSenseDeviceController.dart';
part 'view/ScanPage.dart';

void main() => runApp(const HeatSenseApp());

class HeatSenseApp extends StatelessWidget {
  const HeatSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarHeatSense(),
    );
  }
}
