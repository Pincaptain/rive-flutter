import 'package:flutter/material.dart';

class ShareCodeUnauthorizedException implements Exception{
  final String errorMessage;

  ShareCodeUnauthorizedException({
    @required this.errorMessage,
  });
}

class ShareCodeInternalServerException implements Exception{
  final String errorMessage;

  ShareCodeInternalServerException({
    @required this.errorMessage,
  });
}

class ShareCodeUnexpectedException implements Exception {
  final String errorMessage;

  ShareCodeUnexpectedException({
    @required this.errorMessage,
  });
}