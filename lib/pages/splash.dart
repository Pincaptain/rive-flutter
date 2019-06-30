import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:location/location.dart';

import 'package:rive_flutter/blocs/splash_bloc.dart';
import 'package:rive_flutter/pages/map.dart';

class SplashPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SplashPageState();

}

class SplashPageState extends State<SplashPage> {

  SplashBloc splashBloc;

  Flushbar locationPermissionFlushbar;

  StreamSubscription validationSubscription;

  @override
  initState() {
    super.initState();
    
    splashBloc = SplashBloc();
    locationPermissionFlushbar = Flushbar(
      messageText: Text(
        'We need your location permission to show scooters on map.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      isDismissible: false,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      aroundPadding: EdgeInsets.all(8),
      borderRadius: 8,
    );

    initStreams();
    requestLocationPermission();
  }

  initStreams() {
    splashBloc.locationPermissionBloc.state.listen(onLocationPermissionResult);
    
    validationSubscription = Observable.combineLatest2(
      Connectivity().onConnectivityChanged,
      splashBloc.locationPermissionBloc.state,
      validateConnectivityAndPermissions
    ).listen((valid) => print(valid));
  }

  onLocationPermissionResult(bool decision) {
    if (!decision) {
      locationPermissionFlushbar.show(context);
    } else {
      if (locationPermissionFlushbar != null) {
        locationPermissionFlushbar.dismiss(context);
      }
    }
  }

  validateConnectivityAndPermissions(connectivityResult, locationPermissionResult) {
    if (connectivityResult != ConnectivityResult.none && locationPermissionResult) {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapPage()),
        );
      });
    }

    return true;
  }

  requestLocationPermission() async {
    var location = Location();
    var permission = await location.hasPermission();

    if (!permission) {
      permission = await location.requestPermission();
    }

    splashBloc.locationPermissionBloc.dispatch(permission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          initialData: ConnectivityResult.none,
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return FlareActor(
                'assets/images/Error.flr'
              );
            } else if (snapshot.data == ConnectivityResult.none) {          
              return FlareActor(
                'assets/images/NoConnection.flr'
              );
            } else {
              return FlareActor(
                'assets/images/Scooter.flr'
              );
            }
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    splashBloc.dispose();
    validationSubscription.cancel();
  }
  
}