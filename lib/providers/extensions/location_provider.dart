import 'dart:io';
import 'dart:convert';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/models/extensions.dart';
import 'package:rive_flutter/providers/extensions/location_provider_exceptions.dart';

class LocationApiProvider {
  final providerUrl = '${Client.client}/api/rides';

  Future<void> sendLocation(LocationData locationData) async {
    final locationModel = LocationModel(
      locationData.latitude,
      locationData.longitude,
      locationData.altitude,
      locationData.time,
      locationData.speed,
      locationData.heading,
      locationData.accuracy,
      locationData.speedAccuracy
    );

    var response = await http.post(
      Uri.encodeFull('$providerUrl/send_location/'),
      headers: {
        'Authorization': Token.getHeaderToken(),
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: json.encode(locationModel.toJson()),
    );

    switch (response.statusCode) {
      case 200:
        return;

      case 400:
        throw LocationBadRequestException();

      case 401:
        throw LocationUnauthorizedException();

      case 500:
        throw LocationInternalServerException();

      default:
        throw LocationUnexpectedException();
    }
  }
}