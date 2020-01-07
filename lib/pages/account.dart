import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/pages/login.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc_states.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc_events.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final accountFormKey = GlobalKey<FormBuilderState>();
  final accountPlaceholderKey = GlobalKey<FormBuilderState>();

  AccountBloc accountBloc;

  @override
  void initState() {
    super.initState();

    accountBloc = AccountBloc();
    accountBloc.add(AccountSelfEvent());
  }

  void onLogout() async {
    Token.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => accountBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('account.title'),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: onLogout,
              icon: Icon(
                Icons.exit_to_app
              ),
              tooltip: AppLocalizations.of(context).tr('account.logout_button'),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Container(
                width: 200,
                height: 200,
                child: FlareActor(
                  'assets/images/ProfileAvatar.flr',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  return createAccountForm(state);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createAccountForm(AccountState state) {
    if (state is AccountSuccessState) {
      return FormBuilder(
        key: accountFormKey,
        initialValue: createFormInitialValues(state),
        readOnly: true,
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              attribute: "username",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.username_label'),
              ),
            ),
            FormBuilderTextField(
              attribute: "first_name",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.first_name_label'),
              ),
            ),
            FormBuilderTextField(
              attribute: "last_name",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.last_name_label'),
              ),
            ),
            FormBuilderTextField(
              attribute: "email",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.email_label'),
              ),
            ),
            FormBuilderTextField(
              attribute: "phone_number",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.phone_number_label'),
              ),
            ),
          ],
        ),
      );
    } else {
      return FormBuilder(
        key: accountPlaceholderKey,
        initialValue: createFormInitialValues(state),
        readOnly: true,
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              attribute: "username",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.username_label'),
              ),
            ),
            FormBuilderTextField(
              attribute: "first_name",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.first_name_label'),
              ),
            ),
            FormBuilderTextField(
              attribute: "last_name",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.last_name_label'),
              ),
            ),
            FormBuilderTextField(
              attribute: "email",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.email_label'),
              ),
            ),
            FormBuilderTextField(
              attribute: "phone_number",
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tr('account.phone_number_label'),
              ),
            ),
          ],
        ),
      );
    }
  }

  Map<String, dynamic> createFormInitialValues(AccountState state) {
    var initialValues = {
      'username': '',
      'first_name': '',
      'last_name': '',
      'email': '',
      'phone_number': '',
    };

    if (state is AccountSuccessState) {
      initialValues['username'] = state.user.username;
      initialValues['first_name'] = state.user.firstName;
      initialValues['last_name'] = state.user.lastName;
      initialValues['email'] = state.user.email;
      initialValues['phone_number'] = state.user.phoneNumber == null ? '' : state.user.phoneNumber;
    }

    return initialValues;
  }

  @override
  void dispose() {
    super.dispose();
    accountBloc.close();
  }
}