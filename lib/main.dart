import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bloc/bloc.dart';

import 'package:rive_flutter/pages/splash.dart';
import 'package:rive_flutter/delegates/base_delegate.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  BlocSupervisor.delegate = BaseBlocDelegate();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
    .then((_) {
      Token.tryAuthenticate();
      runApp(RiveApp());
    });
}

class RiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rive',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: AppBarTheme(
          color: Colors.teal[400],
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
