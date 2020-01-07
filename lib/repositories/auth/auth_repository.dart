import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/providers/auth/auth_provider.dart';

class AuthenticationRepository {
  AuthenticationApiProvider authenticationApiProvider = AuthenticationApiProvider();
  AuthenticationSharedPreferencesProvider authenticationSharedPreferencesProvider = AuthenticationSharedPreferencesProvider();

  Future<TokenModel> login(LoginModel loginModel) =>
      authenticationApiProvider.login(loginModel);

  Future<TokenModel> register(RegisterModel registerModel) =>
      authenticationApiProvider.register(registerModel);

  Future<User> fetchCurrentUser() => authenticationApiProvider.fetchCurrentUser();

  Future<bool> storeToken(String token) => authenticationSharedPreferencesProvider.storeToken(token);

  Future<String> fetchToken() => authenticationSharedPreferencesProvider.fetchToken();

  Future<bool> discardToken() => authenticationSharedPreferencesProvider.discardToken();
}