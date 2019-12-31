import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/providers/auth/auth_provider.dart';

class AuthenticationRepository {
  AuthenticationApiProvider authenticationApiProvider = AuthenticationApiProvider();

  Future<TokenModel> login(LoginModel loginModel) =>
      authenticationApiProvider.login(loginModel);

  Future<TokenModel> register(RegisterModel registerModel) =>
      authenticationApiProvider.register(registerModel);
}