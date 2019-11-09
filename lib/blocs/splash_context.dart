import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:connectivity/connectivity.dart';
import 'package:rive_flutter/blocs/extensions/location_bloc.dart';

class SplashContext {
  LocationPermissionBloc locationPermissionBloc;

  Stream splashValidation;

  SplashContext() {
    locationPermissionBloc = LocationPermissionBloc();

    splashValidation = Observable.combineLatest2(
      Connectivity().onConnectivityChanged,
      locationPermissionBloc.state,
      validateConnectivityAndPermissions
    );
  }

  bool validateConnectivityAndPermissions(ConnectivityResult connectivityResult, bool locationPermissionResult) {
    return connectivityResult != ConnectivityResult.none && locationPermissionResult;
  }

  void dispose() {
    locationPermissionBloc.dispose();
  }
}
