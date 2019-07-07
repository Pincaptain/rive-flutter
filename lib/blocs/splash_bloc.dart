import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';

class LocationPermissionBloc extends Bloc<bool, bool> {
  @override
  bool get initialState => false;

  Timer locationPermissionTimer;

  LocationPermissionBloc() {
    locationPermissionTimer = Timer.periodic(Duration(seconds: 1), requestLocationPermission);
  }

  @override
  Stream<bool> mapEventToState(bool event) async* {
    yield event;
  }

  void requestLocationPermission(timer) async {
    var location = Location();
    var permission = await location.hasPermission();

    if (!permission) {
      permission = await location.requestPermission();
    }

    dispatch(permission);
  }

  @override
  void dispose() {
    super.dispose();
    locationPermissionTimer.cancel();
  }
}

class SplashBloc {
  LocationPermissionBloc locationPermissionBloc;

  Stream splashValidation;

  SplashBloc() {
    locationPermissionBloc = LocationPermissionBloc();

    splashValidation = Observable.combineLatest2(
      Connectivity().onConnectivityChanged,
      locationPermissionBloc.state,
      validateConnectivityAndPermissions
    );
  }

  bool validateConnectivityAndPermissions(connectivityResult, locationPermissionResult) {
    return connectivityResult != ConnectivityResult.none && locationPermissionResult;
  }

  void dispose() {
    locationPermissionBloc.dispose();
  }
}
