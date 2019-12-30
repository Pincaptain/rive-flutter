import 'package:flutter/cupertino.dart';

import 'package:rive_flutter/models/core.dart';

abstract class RideEvent {}

abstract class RideStatusEvent extends RideEvent {}

class RideStatusCheckEvent extends RideStatusEvent {}

class BeginRideEvent extends RideEvent {
  final String qrCode;

  BeginRideEvent({
    @required this.qrCode
  });
}

class RideCheckEvent extends RideEvent {}

class EndRideEvent extends RideEvent {}

abstract class HistoryEvent extends RideEvent {}

class HistoryListEvent extends HistoryEvent {}

class HistoryPaginatedEvent extends HistoryEvent {
  final int page;

  HistoryPaginatedEvent({
    @required this.page,
  });
}

abstract class ReviewEvent extends RideEvent {}

class ReviewSendEvent extends ReviewEvent {
  final ReviewModel reviewModel;

  ReviewSendEvent({
    @required this.reviewModel,
  });
}