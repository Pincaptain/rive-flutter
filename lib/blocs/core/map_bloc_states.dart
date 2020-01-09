import 'package:flutter/material.dart';

import 'package:rive_flutter/models/core.dart';

abstract class MapState {}

abstract class ScootersState extends MapState {}

abstract class StationsState extends MapState {}

class MapUninitializedState extends MapState {}

class ScootersUninitializedState extends ScootersState {}

class ScootersFetchingState extends ScootersState {}


class ScootersEmptyState extends ScootersState {}

class ScootersErrorState extends ScootersState {
  final String errorMessage;

  ScootersErrorState({
    @required this.errorMessage
  });
}

class MapElementsSuccessState extends MapState{
  final List<Scooter> scooters;
  final List<Station> stations;

  MapElementsSuccessState({
    @required this.scooters,
    @required this.stations,
  });
}

class ScootersSuccessState extends ScootersState {
  final List<Scooter> scooters;

  ScootersSuccessState({
    @required this.scooters
  });
}

class StationsUninitializedState extends StationsState {}

class StationsFetchingState extends StationsState {}

class StationsErrorState extends StationsState {
  final String errorMessage;

  StationsErrorState({
    @required this.errorMessage
  });
}

class StationsSuccessState extends StationsState {
  final List<Station> stations;

  StationsSuccessState({
    @required this.stations
  });
}