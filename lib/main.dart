library heatsense;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:async';
import 'dart:math';

import 'package:mdsflutter/Mds.dart';
import 'package:mdsflutter/gen/protos/mdsflutter.pb.dart';
import 'package:mdsflutter/gen/protos/mdsflutter.pbenum.dart';
import 'package:mdsflutter/gen/protos/mdsflutter.pbjson.dart';
import 'package:mdsflutter/gen/protos/mdsflutter.pbserver.dart';
import 'package:mdsflutter/internal/MdsImpl.dart';

part 'model/sensor.dart';
//part 'model/movesense_ble_sensor.dart';
part 'view/heatsense_app.dart';

void main() => runApp(const HeatSenseApp());

class HeatSenseApp extends StatelessWidget {
  const HeatSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}
