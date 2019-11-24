import 'package:rive_flutter/blocs/auth/auth_bloc.dart';

class RegisterContext {
  RegisterBloc registerBloc;

  RegisterContext() {
    registerBloc = RegisterBloc();
  }

  void dispose() {
    registerBloc.dispose();
  }
}