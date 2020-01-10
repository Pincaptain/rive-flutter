import 'package:flutter/material.dart';

import 'package:rive_flutter/models/core.dart';

abstract class MapState {}

class MapUninitializedState extends MapState {}

class MapElementsSuccessState extends MapState {
  final List<Scooter> scooters;
  final List<Station> stations;

  MapElementsSuccessState({
    @required this.scooters,
    @required this.stations,
  });
}

abstract class ScootersState extends MapState {}

class ScootersFetchingState extends ScootersState {}

class ScootersSuccessState extends ScootersState {
  final List<Scooter> scooters;

  ScootersSuccessState({
    @required this.scooters
  });
}

class ScootersEmptyState extends ScootersState {}

class ScootersErrorState extends ScootersState {
  final String errorMessage;

  ScootersErrorState({
    @required this.errorMessage
  });
}

abstract class StationsState extends MapState {}

class StationsFetchingState extends StationsState {}

class StationsSuccessState extends StationsState {
  final List<Station> stations;

  StationsSuccessState({
    @required this.stations
  });
}

class StationsErrorState extends StationsState {
  final String errorMessage;

  StationsErrorState({
    @required this.errorMessage
  });
}

