import 'package:flutter/material.dart';

import 'package:rive_flutter/models/core.dart';

class RideStatusUnauthorizedException implements Exception {}

class RideStatusInternalServerException implements Exception {}

class RideStatusUnexpectedException implements Exception {}

class BeginRideBadRequestException implements Exception {
  RideErrorModel rideErrorModel;

  BeginRideBadRequestException({
    @required this.rideErrorModel,
  });

  String getErrorMessage() {
    return rideErrorModel.errorMessage;
  }
}

class BeginRideUnauthorizedException implements Exception {
  final String errorMessage;

  BeginRideUnauthorizedException({
    @required this.errorMessage,
  });
}

class BeginRideInternalServerException implements Exception {
  final String errorMessage;

  BeginRideInternalServerException({
    @required this.errorMessage,
  });
}

class BeginRideUnexpectedException implements Exception {
  final String errorMessage;

  BeginRideUnexpectedException({
    @required this.errorMessage,
  });
}

class RideBadRequestException implements Exception {
  RideErrorModel rideErrorModel;

  RideBadRequestException({
    @required this.rideErrorModel
  });

  String getErrorMessage() {
    return rideErrorModel.errorMessage;
  }
}

class RideUnauthorizedException implements Exception {
  final String errorMessage;

  RideUnauthorizedException({
    @required this.errorMessage,
  });
}

class RideInternalServerException implements Exception {
  final String errorMessage;

  RideInternalServerException({
    @required this.errorMessage,
  });
}

class RideUnexpectedException implements Exception {
  final String errorMessage;

  RideUnexpectedException({
    @required this.errorMessage,
  });
}

class EndRideBadRequestException implements Exception {
  final String errorMessage;

  EndRideBadRequestException({
    @required this.errorMessage
  });
}

class EndRideUnauthorizedException implements Exception {
  final String errorMessage;

  EndRideUnauthorizedException({
    @required this.errorMessage
  });
}

class EndRideInternalServerException implements Exception {
  final String errorMessage;

  EndRideInternalServerException({
    @required this.errorMessage,
  });
}

class EndRideUnexpectedException implements Exception {
  final String errorMessage;

  EndRideUnexpectedException({
    @required this.errorMessage,
  });
}

class HistoryBadRequestException implements Exception {
  final String errorMessage;

  HistoryBadRequestException({
    @required this.errorMessage
  });
}

class HistoryUnauthorizedException implements Exception {
  final String errorMessage;

  HistoryUnauthorizedException({
    @required this.errorMessage
  });
}

class HistoryPageNotFoundException implements Exception {
  final String errorMessage;

  HistoryPageNotFoundException({
    @required this.errorMessage,
  });
}

class HistoryInternalServerException implements Exception {
  final String errorMessage;

  HistoryInternalServerException({
    @required this.errorMessage,
  });
}

class HistoryUnexpectedException implements Exception {
  final String errorMessage;

  HistoryUnexpectedException({
    @required this.errorMessage,
  });
}

class ReviewBadRequestException implements Exception {
  final ReviewErrorModel reviewErrorModel;

  ReviewBadRequestException({
    @required this.reviewErrorModel
  });

  String getErrorMessage() {
    return reviewErrorModel.errorMessage;
  }
}

class ReviewUnauthorizedException implements Exception {
  final String errorMessage;

  ReviewUnauthorizedException({
    @required this.errorMessage
  });
}

class ReviewInternalServerException implements Exception {
  final String errorMessage;

  ReviewInternalServerException({
    @required this.errorMessage
  });
}

class ReviewUnexpectedException implements Exception {
  final String errorMessage;

  ReviewUnexpectedException({
    @required this.errorMessage
  });
}