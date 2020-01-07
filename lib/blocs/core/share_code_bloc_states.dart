import 'package:flutter/material.dart';

import 'package:rive_flutter/models/core.dart';

abstract class ShareCodeState {}

class ShareCodeUninitializedState extends ShareCodeState {}

class ShareCodeFetchingState extends ShareCodeState {}

class ShareCodeSuccessState extends ShareCodeState {
  final ShareCode shareCode;

  ShareCodeSuccessState({
    @required this.shareCode,
  });
}

class ShareCodeErrorState extends ShareCodeState {
  final String errorMessage;

  ShareCodeErrorState({
    @required this.errorMessage,
  });
}
