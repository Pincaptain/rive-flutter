import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/blocs/core/scooters_bloc.dart';
import 'package:rive_flutter/blocs/extensions/location_bloc.dart';

class MapContext {
  ScootersBloc scootersBloc;
  LocationPermissionBloc locationPermissionBloc;
  BeginRideBloc beginRideBloc;
  RideStatusBloc rideStatusBloc;

  MapContext() {
    scootersBloc = ScootersBloc();
    locationPermissionBloc = LocationPermissionBloc();
    beginRideBloc = BeginRideBloc();
    rideStatusBloc = RideStatusBloc();
  }

  void dispose() {
    scootersBloc.dispose();
    locationPermissionBloc.dispose();
    beginRideBloc.dispose();
    rideStatusBloc.dispose();
  }
}