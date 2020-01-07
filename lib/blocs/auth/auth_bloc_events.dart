import 'package:flutter/material.dart';

import 'package:rive_flutter/models/auth.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final LoginModel loginModel;

  LoginEvent({
    @required this.loginModel
  });
}

class RegisterEvent extends AuthEvent {
  final RegisterModel registerModel;

  RegisterEvent({
    @required this.registerModel
  });
}

abstract class AccountEvent extends AuthEvent {}

class AccountSelfEvent extends AccountEvent {}