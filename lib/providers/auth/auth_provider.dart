import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/providers/auth/auth_provider_exceptions.dart';

class AuthenticationApiProvider {
  final providerUrl = '${Client.client}/api/users/rest-auth';

  Future<TokenModel> login(LoginModel loginModel) async {
    var response = await http.post(
        Uri.encodeFull('$providerUrl/login/'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: json.encode(loginModel.toJson()),
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var tokenModel = TokenModel.fromJson(jsonData);

        return tokenModel;

      case 400:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var loginErrorModel = LoginErrorModel.fromJson(jsonData);

        throw LoginBadRequestException(
          loginErrorModel: loginErrorModel,
        );

      case 500:
        throw LoginInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw LoginUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }

  Future<TokenModel> register(RegisterModel registerModel) async {
    var response = await http.post(
      Uri.encodeFull('$providerUrl/register/'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: json.encode(registerModel.toJson()),
    );

    switch (response.statusCode) {
      case 200:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var tokenModel = TokenModel.fromJson(jsonData);

        return tokenModel;

      case 400:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var registerErrorModel = RegisterErrorModel.fromJson(jsonData);

        throw RegisterBadRequestException(
          registerErrorModel: registerErrorModel,
        );

      case 500:
        throw RegisterInternalServerException(
          errorMessage: 'An error occurred on the server. '
              'This may be due to maintenance. Please try again soon!',
        );

      default:
        throw RegisterUnexpectedException(
          errorMessage: 'This is a weird problem. '
              'Probably a result of time travel or a genious mind! '
              'If this problem persists contact support!',
        );
    }
  }
}