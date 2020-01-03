import 'package:bloc/bloc.dart';

import 'package:rive_flutter/locator.dart';
import 'package:rive_flutter/blocs/core/share_code_bloc_events.dart';
import 'package:rive_flutter/blocs/core/share_code_bloc_states.dart';
import 'package:rive_flutter/providers/core/share_code_provider_exceptions.dart';
import 'package:rive_flutter/repositories/core/share_code_repository.dart';


class ShareCodeBloc extends Bloc<ShareCodeEvent, ShareCodeState> {
  ShareCodeRepository shareCodeRepository = getIt<ShareCodeRepository>();

  @override
  ShareCodeState get initialState => ShareCodeUninitializedState();

  @override
  Stream<ShareCodeState> mapEventToState(ShareCodeEvent event) async* {
    yield ShareCodeFetchingState();

    try {
      final shareCodeModel = await shareCodeRepository.fetchShareCode();

      yield ShareCodeSuccessState(
          code: shareCodeModel.code
      );
    } on ShareCodeUnauthorizedException catch (exc) {
      yield ShareCodeErrorState(
        errorMessage: exc.errorMessage,
      );
    } on ShareCodeUnexpectedException catch (exc) {
      yield ShareCodeErrorState(
        errorMessage: exc.errorMessage,
      );
    } on ShareCodeInternalServerException catch (exc) {
      yield ShareCodeErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }
}