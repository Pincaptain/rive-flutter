import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/providers/core/ride_provider_exceptions.dart';

class RideApiProvider {
  final providerUrl = '${Client.client}/api/rides';

  Future<RideStatus> fetchRideStatus() async {
    var response = await http.get(
      Uri.encodeFull('$providerUrl/ride_status/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: Token.getHeaderToken(),
      },
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var rideStatus = RideStatus.fromJson(jsonData);

        return rideStatus;

      case 401:
        throw RideStatusUnauthorizedException();

      case 500:
        throw RideStatusInternalServerException();

      default:
        throw RideStatusUnexpectedException();
    }
  }

  Future<Ride> beginRide(String qrCode) async {
    var response = await http.get(
      Uri.encodeFull('$providerUrl/$qrCode/rent/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: Token.getHeaderToken(),
      },
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var ride = Ride.fromJson(jsonData);

        return ride;

      case 400:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var rideErrorModel = RideErrorModel.fromJson(jsonData);

        throw BeginRideBadRequestException(
          rideErrorModel: rideErrorModel,
        );

      case 401:
        throw BeginRideUnauthorizedException(
          errorMessage: 'Only authenticated users can begin a ride!',
        );

      case 500:
        throw BeginRideInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw BeginRideUnexpectedException(
          errorMessage: 'This is a weird problem. '
          'Probably a result of time travel or a genious mind! '
          'If this problem persists contact support!',
        );
    }
  }

  Future<Ride> fetchRide() async {
    var response = await http.get(
      Uri.encodeFull('$providerUrl/current/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: Token.getHeaderToken(),
      },
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var ride = Ride.fromJson(jsonData);

        return ride;

      case 400:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var rideErrorModel = RideErrorModel.fromJson(jsonData);

        throw RideBadRequestException(
          rideErrorModel: rideErrorModel,
        );

      case 401:
        throw RideUnauthorizedException(
          errorMessage: 'Only authenticated users can get their ride!',
        );

      case 500:
        throw RideInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw RideUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }

  Future<void> endRide() async {
    var response = await http.get(
      Uri.encodeFull('$providerUrl/end_ride/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: Token.getHeaderToken(),
      },
    );

    switch (response.statusCode) {
      case 200:
        return;

      case 400:
        throw EndRideBadRequestException(
          errorMessage: 'Something went wrong! You cannot end your ride.',
        );

      case 401:
        throw EndRideUnauthorizedException(
          errorMessage: 'Only authenticated users can end their ride!',
        );

      case 500:
        throw EndRideInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw EndRideUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }

  Future<List<Ride>> fetchHistory() async {
    var response = await http.get(
      Uri.encodeFull('$providerUrl/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: Token.getHeaderToken(),
      },
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var history = await Stream.fromIterable(jsonData)
            .map((value) => Ride.fromJson(value))
            .toList();

        return history;

      case 400:
        throw HistoryBadRequestException(
          errorMessage: 'Something went wrong! '
              'We are unable to get your ride history.'
        );

      case 401:
        throw HistoryUnauthorizedException(
          errorMessage: 'Only authenticated users can view their ride history!',
        );

      case 500:
        throw HistoryInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw HistoryUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }

  Future<List<Ride>> fetchHistoryPaginated(int page) async {
    var response = await http.get(
      Uri.encodeFull('$providerUrl/paginated/?page=$page'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: Token.getHeaderToken(),
      },
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var historyPaginated = HistoryPaginated.fromJson(jsonData);

        return historyPaginated.history;

      case 400:
        throw HistoryBadRequestException(
            errorMessage: 'Something went wrong! '
                'We are unable to get your ride history.'
        );

      case 401:
        throw HistoryUnauthorizedException(
          errorMessage: 'Only authenticated users can view their ride history!',
        );

      case 404:
        throw HistoryPageNotFoundException(
          errorMessage: 'You already reached your end of history.',
        );

      case 500:
        throw HistoryInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw HistoryUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }

  Future<void> sendReview(ReviewModel reviewModel) async {
    var response = await http.post(
      Uri.encodeFull('${Client.client}/api/reviews/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: Token.getHeaderToken(),
      },
      body: json.encode(reviewModel.toJson()),
    );

    switch (response.statusCode) {
      case 200:
        return;

      case 400:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var reviewErrorModel = ReviewErrorModel.fromJson(jsonData);

        throw ReviewBadRequestException(
          reviewErrorModel: reviewErrorModel,
        );

      case 401:
        throw ReviewUnauthorizedException(
          errorMessage: 'Only authenticated users can submit a review!',
        );

      case 500:
        throw ReviewInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw ReviewUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }
}