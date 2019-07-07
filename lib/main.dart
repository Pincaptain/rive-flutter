import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:rive_flutter/pages/splash.dart';
import 'package:rive_flutter/blocs/delegates/base_delegate.dart';

void main() {
  BlocSupervisor.delegate = BaseBlocDelegate();

  runApp(RiveApp());
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
