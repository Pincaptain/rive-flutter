import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';

class HelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('help.title'),
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
                AppLocalizations.of(context).tr('help.development_title'),
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
                  AppLocalizations.of(context).tr('help.development_description'),
                  style: TextStyle(
                    color: Colors.teal[400],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}