import 'package:flutter/cupertino.dart';

abstract class LocationState {}

abstract class SpeedState extends LocationState {}

class SpeedUninitializedState extends SpeedState {}

class SpeedZeroState extends SpeedState {}

class SpeedNonZeroState extends SpeedState {
  final double speed;

  SpeedNonZeroState({
    @required this.speed,
  });
}

abstract class LocationPermissionState extends LocationState {}

class LocationPermissionUninitializedState extends LocationPermissionState {}

class LocationPermissionAllowedState extends LocationPermissionState {}

class LocationPermissionDisallowedState extends LocationPermissionState {}