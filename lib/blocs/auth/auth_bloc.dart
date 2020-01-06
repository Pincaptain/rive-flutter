import 'package:bloc/bloc.dart';

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc_events.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc_states.dart';
import 'package:rive_flutter/providers/auth/auth_provider_exceptions.dart';
import 'package:rive_flutter/repositories/auth/auth_repository.dart';
import 'package:rive_flutter/locator.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthenticationRepository authenticationRepository = getIt<AuthenticationRepository>();

  @override
  LoginState get initialState => LoginUninitializedState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    yield LoginFetchingState();

    try {
      final tokenModel = await authenticationRepository.login(event.loginModel);

      Token.authenticate(tokenModel.token);
      yield LoginSuccessState(
          tokenModel: tokenModel,
      );
    } on LoginBadRequestException catch (exc) {
      yield LoginErrorState(
        errorMessage: exc.getErrorMessage(),
      );
    } on LoginInternalServerException catch (exc) {
      yield LoginErrorState(
        errorMessage: exc.errorMessage,
      );
    } on LoginUnexpectedException catch (exc) {
      yield LoginErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthenticationRepository authenticationRepository = getIt<AuthenticationRepository>();

  @override
  RegisterState get initialState => RegisterUninitializedState();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    yield RegisterFetchingState();

    try {
      final tokenModel = await authenticationRepository.register(event.registerModel);

      Token.authenticate(tokenModel.token);
      yield RegisterSuccessState(
        tokenModel: tokenModel,
      );
    } on RegisterBadRequestException catch (exc) {
      yield RegisterErrorState(
          errorMessage: exc.getErrorMessage(),
      );
    } on RegisterInternalServerException catch (exc) {
      yield RegisterErrorState(
        errorMessage: exc.errorMessage,
      );
    } on RegisterUnexpectedException catch (exc) {
      yield RegisterErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }
}

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AuthenticationRepository authenticationRepository = getIt<AuthenticationRepository>();

  @override
  AccountState get initialState => AccountUninitializedState();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    yield AccountFetchingState();

    try {
      final user = await authenticationRepository.fetchCurrentUser();

      yield AccountSuccessState(
        user: user,
      );
    } on AccountUnauthorizedException catch (exc) {
      yield AccountErrorState(
        errorMessage: exc.errorMessage,
      );
    } on AccountInternalServerException catch (exc) {
      yield AccountErrorState(
        errorMessage: exc.errorMessage,
      );
    } on AccountUnexpectedException catch (exc) {
      yield AccountErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }
}