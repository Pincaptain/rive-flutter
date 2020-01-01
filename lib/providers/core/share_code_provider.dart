import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rive_flutter/providers/core/share_code_provider_exceptions.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/models/core.dart';

class ShareCodeProvider {
  final providerUrl = '${Client.client}/api/rides';

  Future<ShareCode> fetchShareCode() async {
    var response = await http.get(
        Uri.encodeFull('$providerUrl/share_code/'),
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

          ShareCode shareCodeTest= ShareCode('ABCDEE');

//        return shareCode;
          return shareCodeTest;
      case 401:
        throw ShareCodeUnauthorizedException(
          errorMessage: 'You are not authenticated!'
        );
      case 500:
        throw ShareCodeInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!'
        );
      default:
        throw ShareCodeUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!'
        );
    }
  }
}