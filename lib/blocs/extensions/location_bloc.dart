import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';

class SpeedBloc extends Bloc<LocationData, double> {
  @override
  double get initialState => 0;

  StreamSubscription locationSubscription;

  SpeedBloc() {
    locationSubscription = Location().onLocationChanged().listen(onLocationData);
  }

  @override
  Stream<double> mapEventToState(LocationData locationData) async* {
    if (locationData.speed == 0) {
      yield 0;
    }
    
    yield locationData.speed * 3600 / 1000;
  }

  void onLocationData(LocationData locationData) {
    dispatch(locationData);
  }

  @override
  void dispose() {
    super.dispose();
    locationSubscription.cancel();
  }
}

class LocationPermissionBloc extends Bloc<bool, bool> {
  Timer locationPermissionTimer;

  LocationPermissionBloc() {
    locationPermissionTimer = Timer.periodic(Duration(seconds: 1), getLocationPermission);
  }

  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(bool isAllowed) async* {
    yield isAllowed;
  }

  void getLocationPermission(Timer timer) async {
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