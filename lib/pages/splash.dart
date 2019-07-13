import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';

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
  }

  void initStreams() {
    splashBloc.locationPermissionBloc.state.listen(onLocationPermissionResult);
    validationSubscription = splashBloc.splashValidation.listen(onValidation);
  }

  void onLocationPermissionResult(bool permission) {
    if (!permission) {
      locationPermissionFlushbar.show(context);
    } else {
      if (locationPermissionFlushbar != null) {
        locationPermissionFlushbar.dismiss(context);
      }
    }
  }

  void onValidation(valid) {
    if (valid) {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MapPage()
          ),
        );
      });
    }
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