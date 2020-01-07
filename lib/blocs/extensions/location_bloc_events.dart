import 'package:flutter/material.dart';

import 'package:location/location.dart';

abstract class LocationEvent {}

class SpeedEvent extends LocationEvent {
  final LocationData locationData;

  SpeedEvent({
    @required this.locationData,
  });
}

class LocationPermissionEvent extends LocationEvent {
  final bool permissionAllowed;

  LocationPermissionEvent({
    @required this.permissionAllowed
  });
}