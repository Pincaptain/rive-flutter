import 'package:flutter/cupertino.dart';

import 'package:rive_flutter/models/auth.dart';

abstract class AuthState {}

abstract class LoginState extends AuthState {}

class LoginUninitializedState extends LoginState {}

class LoginFetchingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String errorMessage;

  LoginErrorState({
    @required this.errorMessage
  });
}

class LoginSuccessState extends LoginState {
  final TokenModel tokenModel;

  LoginSuccessState({
    @required this.tokenModel
  });
}

abstract class RegisterState extends AuthState {}

class RegisterUninitializedState extends RegisterState {}

class RegisterFetchingState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String errorMessage;

  RegisterErrorState({
    @required this.errorMessage
  });
}

class RegisterSuccessState extends RegisterState {
  final TokenModel tokenModel;

  RegisterSuccessState({
    @required this.tokenModel
  });
}

abstract class AccountState extends AuthState {}

class AccountUninitializedState extends AccountState {}

class AccountFetchingState extends AccountState {}

class AccountErrorState extends AccountState {
  final String errorMessage;

  AccountErrorState({
    @required this.errorMessage,
  });
}

class AccountSuccessState extends AccountState {
  final User user;

  AccountSuccessState({
    @required this.user,
  });
}
