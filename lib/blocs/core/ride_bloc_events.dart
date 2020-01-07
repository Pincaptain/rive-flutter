import 'package:flutter/material.dart';

import 'package:rive_flutter/models/core.dart';

abstract class RideEvent {}

class RideCheckEvent extends RideEvent {}

abstract class RideStatusEvent extends RideEvent {}

class RideStatusCheckEvent extends RideStatusEvent {}

class BeginRideEvent extends RideEvent {
  final String qrCode;

  BeginRideEvent({
    @required this.qrCode
  });
}

class EndRideEvent extends RideEvent {}

abstract class HistoryEvent extends RideEvent {}

class HistoryListEvent extends HistoryEvent {}

class HistoryPaginatedEvent extends HistoryEvent {}

abstract class ReviewEvent extends RideEvent {}

class ReviewSendEvent extends ReviewEvent {
  final ReviewModel reviewModel;

  ReviewSendEvent({
    @required this.reviewModel,
  });
}