import 'package:flutter/cupertino.dart';

import 'package:rive_flutter/models/core.dart';

abstract class ScootersState {}

class ScootersUninitializedState extends ScootersState {}

class ScootersFetchingState extends ScootersState {}

class ScootersEmptyState extends ScootersState {}

class ScootersErrorState extends ScootersState {
  final String errorMessage;

  ScootersErrorState({
    @required this.errorMessage
  });
}

class ScootersSuccessState extends ScootersState {
  final List<Scooter> scooters;

  ScootersSuccessState({
    @required this.scooters
  });
}