import 'package:flutter/cupertino.dart';

import 'package:rive_flutter/models/core.dart';

abstract class RideState {}

abstract class RideStatusState extends RideState {}

class RideStatusUninitializedState extends RideStatusState {}

class RideStatusFetchingState extends RideStatusState {}

class RideStatusErrorState extends RideStatusState {}

class RideStatusInRideState extends RideStatusState {}

class RideStatusIdleState extends RideStatusState {}

abstract class BeginRideState extends RideState {}

class BeginRideUninitializedState extends BeginRideState {}

class BeginRideFetchingState extends BeginRideState {}

class BeginRideUnauthorizedState extends BeginRideState {
  final String errorMessage;

  BeginRideUnauthorizedState({
    @required this.errorMessage,
  });
}

class BeginRideErrorState extends BeginRideState {
  final String errorMessage;

  BeginRideErrorState({
    @required this.errorMessage,
  });
}

class BeginRideSuccessState extends BeginRideState {
  final Ride ride;

  BeginRideSuccessState({
    @required this.ride,
  });
}

class RideUninitializedState extends RideState {}

class RideFetchingState extends RideState {}

class RideErrorState extends RideState {
  final String errorMessage;

  RideErrorState({
    @required this.errorMessage,
  });
}

class RideSuccessState extends RideState {
  final Ride ride;

  RideSuccessState({
    @required this.ride,
  });
}

abstract class EndRideState extends RideState {}

class EndRideUninitializedState extends EndRideState {}

class EndRideFetchingState extends EndRideState {}

class EndRideUnauthorizedState extends EndRideState {
  final String errorMessage;

  EndRideUnauthorizedState({
    @required this.errorMessage,
  });
}

class EndRideErrorState extends EndRideState {
  final String errorMessage;

  EndRideErrorState({
    @required this.errorMessage,
  });
}

class EndRideSuccessState extends EndRideState {}

abstract class HistoryState extends RideState {}

class HistoryUninitializedState extends HistoryState {}

class HistoryFetchingState extends HistoryState {}

class HistoryErrorState extends HistoryState {
  final String errorMessage;

  HistoryErrorState({
    @required this.errorMessage,
  });
}

class HistorySuccessState extends HistoryState {
  final List<Ride> history;

  HistorySuccessState({
    @required this.history,
  });
}

abstract class ReviewState extends RideState {}

class ReviewUninitializedState extends ReviewState {}

class ReviewFetchingState extends ReviewState {}

class ReviewErrorState extends ReviewState {
  final String errorMessage;

  ReviewErrorState({
    @required this.errorMessage,
  });
}

class ReviewSuccessState extends ReviewState {}