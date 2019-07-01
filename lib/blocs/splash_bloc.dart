import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';

class LocationPermissionBloc extends Bloc<bool, bool> {

  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(bool event) async* {
    yield event;
  }

  requestLocationPermission() async {
    var location = Location();
    var permission = await location.hasPermission();

    if (!permission) {
      permission = await location.requestPermission();
    }

    dispatch(permission);
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

  validateConnectivityAndPermissions(connectivityResult, locationPermissionResult) {
    return connectivityResult != ConnectivityResult.none && locationPermissionResult;
  }

  dispose() {
    locationPermissionBloc.dispose();
  }

}
