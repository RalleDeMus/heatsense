library heatsense;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:collection';

import 'dart:async';
import 'dart:math';

import 'package:mdsflutter/Mds.dart';
import 'package:provider/provider.dart';

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
