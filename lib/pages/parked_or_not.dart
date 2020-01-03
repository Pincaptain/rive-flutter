import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flare_flutter/flare_actor.dart';

class ParkedOrNotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ParkedOrNotPageState();
}

class ParkedOrNotPageState extends State<ParkedOrNotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).tr('parked_or_not.title'),
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
              AppLocalizations.of(context).tr('parked_or_not.development_title'),
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
                AppLocalizations.of(context).tr('parked_or_not.development_description'),
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