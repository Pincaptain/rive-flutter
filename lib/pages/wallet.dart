import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/pages/share_code.dart';

import 'login.dart';

class WalletPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).tr('wallet.title'),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (Token.isAuthenticated()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShareCodePage(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.card_giftcard,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(),
    );
  }
}