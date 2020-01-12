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

class MapErrorState extends MapState {
  final String errorMessage;

  MapErrorState({
    @required this.errorMessage,
  });
}