import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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
      runApp(EasyLocalization(child: RiveApp()));
    });
}

class RiveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: MaterialApp(
        title: 'Rive',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          //app-specific localization
          EasylocaLizationDelegate(
            locale: EasyLocalizationProvider.of(context).data.locale,
            path: 'assets/lang'
          ),
        ],
        supportedLocales: [Locale('en', 'US'), Locale('mk', 'MK')],
        locale: EasyLocalizationProvider.of(context).data.savedLocale,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          appBarTheme: AppBarTheme(
            color: Colors.teal[400],
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}
