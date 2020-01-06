import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rive_flutter/blocs/auth/auth_bloc.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc_events.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc_states.dart';
import 'package:rive_flutter/pages/register.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/pages/account.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormBuilderState>();

  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();

    loginBloc = LoginBloc();

    initStreams();
  }

  void initStreams() {
    loginBloc.listen(onLoginResult);
  }

  void onLoginResult(LoginState state) {
    if (state is LoginSuccessState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    } else if (state is LoginErrorState) {
      createErrorFlushbar(state.errorMessage).show(context);
    }
  }

  void onFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void onLogin() {
    if (loginFormKey.currentState.saveAndValidate()) {
      final loginModel = LoginModel.fromJson(loginFormKey.currentState.value);
      
      loginBloc.add(LoginEvent(
        loginModel: loginModel,
      ));
    }
  }

  void onReset() {
    loginFormKey.currentState.reset();
  }

  void onRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('login.title'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              FormBuilder(
                key: loginFormKey,
                initialValue: {
                  'username': '',
                  'password': '',
                },
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: "username",
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).tr('login.username_label'), 
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: AppLocalizations.of(context).tr('login.username_required_text'),
                        ),
                      ],
                      textInputAction: TextInputAction.next,
                      focusNode: usernameFocusNode,
                      onFieldSubmitted: (value) {
                        onFocusChange(context, usernameFocusNode, passwordFocusNode);
                      },
                    ),
                    FormBuilderTextField(
                      attribute: "password",
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).tr('login.password_label'),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: AppLocalizations.of(context).tr('login.password_required_text'),
                        ),
                      ],
                      obscureText: true,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      focusNode: passwordFocusNode,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return createLoginButton(state);
                    }
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    onPressed: onReset,
                    child: Text(
                      AppLocalizations.of(context).tr('login.reset_button'),
                    ),
                    textColor: Colors.white,
                    color: Colors.teal[400],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).tr('login.no_account'),
                  ),
                  FlatButton(
                    onPressed: onRegister,
                    child: Text(
                      AppLocalizations.of(context).tr('login.register_button'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createLoginButton(LoginState state) {
    Widget displayWidget = Text(
      AppLocalizations.of(context).tr('login.login_button'),
    );

    if (state is LoginFetchingState) {
      displayWidget = Container(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return RaisedButton(
      onPressed: state is LoginFetchingState ? () {} : onLogin,
      child: displayWidget,
      textColor: Colors.white,
      color: Colors.teal[400],
    );
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc.close();
  }
}