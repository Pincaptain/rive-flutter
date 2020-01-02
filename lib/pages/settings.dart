import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flare_flutter/flare_actor.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  AppLocalizations dict;

  @override
  void initState() {
    super.initState();

    dict = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dict.tr('settings.title'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              width: 350,
              height: 350,
              child: FlareActor(
                'assets/images/Error.flr',
              ),
            ),
          ),
          Center(
            child: Text(
              dict.tr('settings.development_title'),
              style: TextStyle(
                color: Colors.teal[400],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              child: Text(
                dict.tr('settings.development_description'),
                style: TextStyle(
                  color: Colors.teal[400],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}