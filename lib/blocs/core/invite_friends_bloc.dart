import 'package:bloc/bloc.dart';
import 'package:rive_flutter/repositories/core/invite_firends_repository.dart';

import '../../locator.dart';
import 'invite_friends_bloc_events.dart';
import 'invite_friends_bloc_states.dart';


class InviteFriendsBloc extends Bloc<InviteFriendsEvent, InviteFriendsState>{
  InviteFriendsRepository inviteFriendsRepository = getIt<InviteFriendsRepository>();

  @override
  // TODO: implement initialState
  InviteFriendsState get initialState => ShareCodeUninitializedState();

  @override
  Stream<InviteFriendsState> mapEventToState(InviteFriendsEvent event) async* {
    yield ShareCodeFetchingState();

    try {

//      final shareCodeModel = await inviteFriendsRepository.register(event.registerModel);
    }
//    catch{
//
//
//    }
//    return null;
  }

}