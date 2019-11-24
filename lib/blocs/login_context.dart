import 'package:rive_flutter/blocs/auth/auth_bloc.dart';

class LoginContext {
  LoginBloc loginBloc;

  LoginContext() {
    loginBloc = LoginBloc();
  }
  
  void dispose() {
    loginBloc.dispose();
  }
}