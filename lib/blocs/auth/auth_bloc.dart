import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'package:rive_flutter/models/auth.dart';

enum LoginErrorType {
  client,
  server
}

class LoginData {
  String token;
  LoginErrorType errorType;
  String errorMessage;

  bool isValid() {
    return errorMessage == null && errorType == null;
  }

  bool isInitial() {
    return token == null && errorType == null && errorMessage == null;
  }
}

class LoginBloc extends Bloc<LoginModel, LoginData> {
  @override
  LoginData get initialState => LoginData();

  @override
  Stream<LoginData> mapEventToState(LoginModel loginModel) {
    return getLoginData(loginModel).asStream();
  }

  Future<LoginData> getLoginData(LoginModel loginModel) async {
    var loginData = LoginData();

    if (Token.isAuthenticated()) {
      loginData.token = Token.token;

      return loginData;
    }

    var response = await http.post(
      Uri.encodeFull('${Client.client}/api/users/rest-auth/login/'),
      body: loginModel.toJson()
    );
    var statusCodeClass = (response.statusCode / 100).floor();

    switch (statusCodeClass) {
      case 4:
        loginData.errorMessage = 'Invalid username and password combination. Please try again!';
        loginData.errorType = LoginErrorType.client;

        return loginData;

      case 5:
        loginData.errorMessage = 'An error occurred on the server. This may be due to maintenance. Please try again soon!';
        loginData.errorType = LoginErrorType.server;

        return loginData;
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var tokenModel = TokenModel.fromJson(jsonData);

    loginData.token = tokenModel.token;
    Token.authenticate(tokenModel.token);

    return loginData;
  }
}

enum RegisterErrorType {
  client,
  server
}

class RegisterData {
  String token;
  RegisterErrorType errorType;
  RegisterErrorModel errorsModel;
  String errorMessage;

  bool isValid() {
    return errorsModel == null && errorMessage == null && errorType == null;
  }

  bool isInitial() {
    return token == null && errorType == null && errorsModel == null && errorMessage == null;
  }
}

class RegisterBloc extends Bloc<RegisterModel, RegisterData> {
  @override
  RegisterData get initialState => RegisterData();

  @override
  Stream<RegisterData> mapEventToState(RegisterModel registerModel) {
    return getRegisterData(registerModel).asStream();
  }

  Future<RegisterData> getRegisterData(RegisterModel registerModel) async {
    var registerData = RegisterData();

    if (Token.isAuthenticated()) {
      registerData.token = Token.token;

      return registerData;
    }

    var response = await http.post(
      Uri.encodeFull('${Client.client}/api/users/rest-auth/register/'),
      body: registerModel.toJson()
    );
    var statusCodeClass = (response.statusCode / 100).floor();

    switch (statusCodeClass) {
      case 4:
        var jsonString = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(jsonString);
        var registerErrorModel = RegisterErrorModel.fromJson(jsonData);

        registerData.errorsModel = registerErrorModel;
        registerData.errorType = RegisterErrorType.client;

        return registerData;

      case 5:
        registerData.errorMessage = 'An error occurred on the server. This may be due to maintenance. Please try again soon!';
        registerData.errorType = RegisterErrorType.server;

        return registerData;
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var tokenModel = TokenModel.fromJson(jsonData);

    registerData.token = tokenModel.token;
    Token.authenticate(tokenModel.token);

    return registerData;
  }
}