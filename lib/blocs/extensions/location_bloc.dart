import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';

import 'package:rive_flutter/blocs/extensions/location_bloc_events.dart';
import 'package:rive_flutter/blocs/extensions/location_bloc_states.dart';

class SpeedBloc extends Bloc<SpeedEvent, SpeedState> {
  @override
  SpeedState get initialState => SpeedUninitializedState();

  StreamSubscription locationSubscription;

  SpeedBloc() {
    locationSubscription = Location()
        .onLocationChanged()
        .listen(onLocationChanged);
  }

  @override
  Stream<SpeedState> mapEventToState(SpeedEvent event) async* {
    if (event.locationData.speed == 0) {
      yield SpeedZeroState();
    }

    final speed = event.locationData.speed * 3600 / 1000;

    yield SpeedNonZeroState(
      speed: speed,
    );
  }

  void onLocationChanged(LocationData locationData) {
    add(SpeedEvent(
      locationData: locationData,
    ));
  }

  @override
  Future<void> close() {
    locationSubscription.cancel();
    return super.close();
  }
}

class LocationPermissionBloc extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  Timer locationPermissionTimer;

  LocationPermissionBloc() {
    locationPermissionTimer = Timer.periodic(Duration(seconds: 1), onLocationPermissionTick);
  }

  @override
  LocationPermissionState get initialState => LocationPermissionUninitializedState();

  @override
  Stream<LocationPermissionState> mapEventToState(LocationPermissionEvent event) async* {
    if (event.permissionAllowed) {
      yield LocationPermissionAllowedState();
    } else {
      LocationPermissionDisallowedState();
    }
  }

  void onLocationPermissionTick(Timer timer) async {
    final location = Location();
    var permission = await location.hasPermission();

    if (!permission) {
      permission = await location.requestPermission();
    }

    add(LocationPermissionEvent(
      permissionAllowed: permission,
    ));
  }

  @override
  Future<void> close() {
    locationPermissionTimer.cancel();
    return super.close();
  }
}