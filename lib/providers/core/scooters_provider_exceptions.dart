import 'package:flutter/material.dart';

class ScootersInternalServerException implements Exception {
  final String errorMessage;

  ScootersInternalServerException({
    @required this.errorMessage,
  });
}

class ScootersUnexpectedException implements Exception {
  final String errorMessage;

  ScootersUnexpectedException({
    @required this.errorMessage,
  });
}