import 'package:flutter/material.dart';

import 'package:flushbar/flushbar.dart';

Flushbar createErrorFlushbar(String errorMessage) {
  return Flushbar(
    messageText: Text(
      errorMessage,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.teal,
    icon: Icon(
      Icons.error,
      color: Colors.white,
    ),
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    duration: Duration(seconds: 3),
  );
}

Flushbar createWarningFlushbar(String warningMessage) {
    return Flushbar(
      messageText: Text(
        warningMessage,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      isDismissible: false,
      icon: Icon(
        Icons.warning,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
    );
  }