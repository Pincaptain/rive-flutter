import 'package:flutter/cupertino.dart';


abstract class InviteFriendsState {}

abstract class ShareCodeState extends InviteFriendsState{}

class ShareCodeUninitializedState extends ShareCodeState {}

class ShareCodeFetchingState extends ShareCodeState{}

class ShareCodeSuccessState extends ShareCodeState{
  final String code;

  ShareCodeSuccessState({
    @required this.code,
  });
}

class ShareCodeErrorState extends ShareCodeState{
  final String errorMessage;

  ShareCodeErrorState({
    @required this.errorMessage,
  });
}
