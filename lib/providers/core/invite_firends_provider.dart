import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/providers/core/ride_provider_exceptions.dart';
import 'package:rive_flutter/providers/core/scooters_provider_exceptions.dart';

class InviteFriendsProvider {
  final providerUrl = '${Client.client}/api/share_code';

  Future<ShareCode> fetchShareCode() async {
    var response = await http.get(
        Uri.encodeFull('$providerUrl/'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': Token.getHeaderToken(),
        },
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var shareCode = ShareCode.fromJson(jsonData);

        return shareCode;
      default:
        throw RideStatusUnauthorizedException();
//
//      case 401:
//        throw RideStatusUnauthorizedException();
//
//      case 500:
//        throw RideStatusInternalServerException();
//
//      default:
//        throw RideStatusUnexpectedException();
    }
  }
}