import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';

import 'package:rive_flutter/pages/map.dart';
import 'package:rive_flutter/blocs/extensions/location_bloc.dart';
import 'package:rive_flutter/blocs/extensions/location_bloc_states.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  LocationPermissionBloc locationPermissionBloc;
  Stream splashValidation;
  StreamSubscription validationSubscription;

  Flushbar locationPermissionFlushbar;

  @override
  initState() {
    super.initState();

    locationPermissionBloc = LocationPermissionBloc();
    splashValidation = Observable.combineLatest2(
        Connectivity().onConnectivityChanged,
        locationPermissionBloc,
        onConnectivityAndLocationPermission
    );
    locationPermissionFlushbar = createErrorFlushbar(AppLocalizations.of(context).tr('splash.location_permission_required'));

    initStreams();
  }

  void initStreams() {
    locationPermissionBloc.listen(onLocationPermissionResult);
    validationSubscription = splashValidation.listen(onSplashValidationResult);
  }

  void onLocationPermissionResult(LocationPermissionState locationPermissionState) {
    if (locationPermissionState is LocationPermissionUninitializedState) {
      return;
    } else if (locationPermissionState is LocationPermissionDisallowedState) {
      locationPermissionFlushbar.show(context);
    } else {
      if (locationPermissionFlushbar != null) {
        locationPermissionFlushbar.dismiss(context);
      }
    }
  }

  void onSplashValidationResult(valid) {
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

  bool onConnectivityAndLocationPermission(ConnectivityResult connectivityResult,
      LocationPermissionState locationPermissionResult) {
    return connectivityResult != ConnectivityResult.none &&
        locationPermissionResult is LocationPermissionAllowedState;
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
    locationPermissionBloc.close();
    validationSubscription.cancel();
  }
}