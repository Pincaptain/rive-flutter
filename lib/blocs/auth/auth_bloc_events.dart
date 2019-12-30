import 'package:flutter/cupertino.dart';

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