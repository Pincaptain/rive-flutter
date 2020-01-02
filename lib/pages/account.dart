import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('account.title'),
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
                AppLocalizations.of(context).tr('account.development_title'),
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
                  AppLocalizations.of(context).tr('account.development_description'),
                  style: TextStyle(
                    color: Colors.teal[400],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}