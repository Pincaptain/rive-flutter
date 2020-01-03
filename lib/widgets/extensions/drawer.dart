import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'package:rive_flutter/pages/account.dart';
import 'package:rive_flutter/pages/help.dart';
import 'package:rive_flutter/pages/history.dart';
import 'package:rive_flutter/pages/login.dart';
import 'package:rive_flutter/pages/parked_or_not.dart';
import 'package:rive_flutter/pages/settings.dart';
import 'package:rive_flutter/pages/wallet.dart';
import 'package:rive_flutter/pages/share_code.dart';
import 'package:rive_flutter/models/auth.dart';

class DrawerWidget extends Drawer {
  final BuildContext context;

  DrawerWidget(this.context);

  void onAccount() {
    if (Token.isAuthenticated()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
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
  }

  void onHistory() {
    if (Token.isAuthenticated()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(),
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
  }

  void onHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpPage(),
      ),
    );
  }

  void onParkedOrNot() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParkedOrNotPage(),
      ),
    );
  }

  void onSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(),
      ),
    );
  }

  void onWallet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WalletPage(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: FlareActor(
                  'assets/images/Scooter.flr'
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).tr('global.extensions.drawer.account_button')),
            trailing: Icon(
              Icons.account_circle,
              color: Colors.blue,
            ),
            onTap: onAccount,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).tr('global.extensions.drawer.wallet_button')),
            trailing: Icon(
              Icons.account_balance_wallet,
              color: Colors.lightGreen,
            ),
            onTap: onWallet,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).tr('global.extensions.drawer.history_button')),
            trailing: Icon(
              Icons.history,
              color: Colors.teal,
            ),
            onTap: onHistory,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).tr('global.extensions.drawer.parked_or_not_button')),
            trailing: Icon(
              Icons.local_parking,
              color: Colors.yellow,
            ),
            onTap: onParkedOrNot,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).tr('global.extensions.drawer.settings_button')),
            trailing: Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            onTap: onSettings,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).tr('global.extensions.drawer.help_button')),
            trailing: Icon(
              Icons.help,
              color: Colors.orange,
            ),
            onTap: onHelp,
          ),
        ],
      ),
    );
  }
}