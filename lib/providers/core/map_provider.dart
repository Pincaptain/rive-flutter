import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/models/core.dart';

import 'map_provider_exceptions.dart';

class StationsApiProvider {
  final providerUrl = '${Client.client}/api/stations';

  Future<List<Station>> fetchStations() async {
    var response = await http.get(
      Uri.encodeFull(providerUrl),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var stations = await Stream.fromIterable(jsonData)
            .map((value) => Station.fromJson(value))
            .toList();

        return stations;
      case 500:
        throw StationsInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw StationsUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }

}

class ScootersApiProvider {
  final providerUrl = '${Client.client}/api/scooters';

  Future<List<Scooter>> fetchScooters() async {
    var response = await http.get(
      Uri.encodeFull('$providerUrl/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var scooters = await Stream.fromIterable(jsonData)
            .map((value) => Scooter.fromJson(value))
            .toList();

        return scooters;

      case 500:
        throw ScootersInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw ScootersUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }
}