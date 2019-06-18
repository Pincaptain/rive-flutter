import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:connectivity/connectivity.dart';

import 'package:rive_flutter/pages/map.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String _imageLocation;

  @override
  initState() {
    super.initState();

    _imageLocation = 'assets/images/Scooter.flr';

    _checkConnection();
  }

  _checkConnection() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
         _imageLocation = 'assets/images/NoConnection.flr';
        });
      } else {
        setState(() {
         _imageLocation = 'assets/images/Scooter.flr';
        });

        _start();
      }
    });
  }

  _start() {
    return new Timer(Duration(seconds: 3), _finish);
  }

  _finish() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MapPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlareActor(
          _imageLocation,
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }
}