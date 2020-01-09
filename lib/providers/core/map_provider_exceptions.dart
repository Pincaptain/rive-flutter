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

class StationsInternalServerException implements Exception {
  final String errorMessage;

  StationsInternalServerException({
    @required this.errorMessage,
  });
}

class StationsUnexpectedException implements Exception {
  final String errorMessage;

  StationsUnexpectedException({
    @required this.errorMessage,
  });
}