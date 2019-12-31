import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';

import 'package:rive_flutter/pages/account.dart';
import 'package:rive_flutter/pages/help.dart';
import 'package:rive_flutter/pages/history.dart';
import 'package:rive_flutter/pages/login.dart';
import 'package:rive_flutter/pages/parked_or_not.dart';
import 'package:rive_flutter/pages/settings.dart';
import 'package:rive_flutter/pages/wallet.dart';
import 'package:rive_flutter/pages/invite_friends.dart';
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

  void onInviteFriends() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteFriendsPage(),
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
            title: Text('Account'),
            trailing: Icon(
              Icons.account_circle,
              color: Colors.blue,
            ),
            onTap: onAccount,
          ),
          ListTile(
            title: Text('Wallet'),
            trailing: Icon(
              Icons.account_balance_wallet,
              color: Colors.lightGreen,
            ),
            onTap: onWallet,
          ),
          ListTile(
            title: Text('Histroy'),
            trailing: Icon(
              Icons.history,
              color: Colors.teal,
            ),
            onTap: onHistory,
          ),
          ListTile(
            title: Text('Parked or Not'),
            trailing: Icon(
              Icons.local_parking,
              color: Colors.yellow,
            ),
            onTap: onParkedOrNot,
          ),
          ListTile(
            title: Text('Settings'),
            trailing: Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            onTap: onSettings,
          ),
          ListTile(
            title: Text('Help'),
            trailing: Icon(
              Icons.help,
              color: Colors.orange,
            ),
            onTap: onHelp,
          ),
          ListTile(
            title: Text('Invite a friend'),
            trailing: Icon(
              Icons.person_add,
              color: Colors.black,
            ),
            onTap: onInviteFriends,
          )
        ],
      ),
    );
  }
}