import 'package:flutter/material.dart';

import 'package:rive_flutter/models/auth.dart';

class LoginBadRequestException implements Exception {
  final LoginErrorModel loginErrorModel;

  LoginBadRequestException({
    @required this.loginErrorModel
  });

  String getErrorMessage() {
    if (loginErrorModel.usernameErrors != null) {
      return loginErrorModel.usernameErrors.first;
    } else if (loginErrorModel.passwordErrors != null) {
      return loginErrorModel.passwordErrors.first;
    } else {
      return loginErrorModel.nonFieldErrors.first;
    }
  }
}

class LoginInternalServerException implements Exception {
  final String errorMessage;

  LoginInternalServerException({
    @required this.errorMessage,
  });
}

class LoginUnexpectedException implements Exception {
  final String errorMessage;

  LoginUnexpectedException({
    @required this.errorMessage,
  });
}

class RegisterBadRequestException implements Exception {
  final RegisterErrorModel registerErrorModel;

  RegisterBadRequestException({
    @required this.registerErrorModel
  });

  String getErrorMessage() {
    if (registerErrorModel.usernameErrors != null) {
      return registerErrorModel.usernameErrors.first;
    } else if (registerErrorModel.emailErrors != null) {
      return registerErrorModel.emailErrors.first;
    } else if (registerErrorModel.password1Errors != null) {
      return registerErrorModel.password1Errors.first;
    } else if (registerErrorModel.password2Errors != null) {
      return registerErrorModel.password2Errors.first;
    } else {
      return registerErrorModel.nonFieldErrors.first;
    }
  }
}

class RegisterInternalServerException implements Exception {
  final String errorMessage;

  RegisterInternalServerException({
    @required this.errorMessage
  });
}

class RegisterUnexpectedException implements Exception {
  final String errorMessage;

  RegisterUnexpectedException({
    @required this.errorMessage
  });
}

class AccountUnauthorizedException implements Exception {
  final String errorMessage;

  AccountUnauthorizedException({
    @required this.errorMessage,
  });
}

class AccountInternalServerException implements Exception {
  final String errorMessage;

  AccountInternalServerException({
    @required this.errorMessage,
  });
}

class AccountUnexpectedException implements Exception {
  final String errorMessage;

  AccountUnexpectedException({
    @required this.errorMessage,
  });
}