import 'package:flutter/material.dart';

import 'package:rive_flutter/pages/splash.dart';

void main() => runApp(RiveApp());

class RiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rive',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
