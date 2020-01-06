import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:rive_flutter/blocs/auth/auth_bloc.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc_events.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc_states.dart';
import 'package:rive_flutter/pages/login.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/pages/account.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final registerFormKey = GlobalKey<FormBuilderState>();

  final usernameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final password1FocusNode = FocusNode();
  final password2FocusNode = FocusNode();

  RegisterBloc registerBloc;

  @override
  void initState() {
    super.initState();

    registerBloc = RegisterBloc();

    initStreams();
  }

  void initStreams() {
    registerBloc.listen(onRegisterResult);
  }

  void onRegisterResult(RegisterState state) {
    if (state is RegisterSuccessState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    } else if (state is RegisterErrorState) {
      createErrorFlushbar(state.errorMessage).show(context);
    }
  }

  void onFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void onRegister() {
    if (registerFormKey.currentState.saveAndValidate()) {
      final registerModel = RegisterModel.fromJson(registerFormKey.currentState.value);

      registerBloc.add(RegisterEvent(
        registerModel: registerModel,
      ));
    }
  }

  void onReset() {
    registerFormKey.currentState.reset();
  }

  void onLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => registerBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('register.title'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              FormBuilder(
                key: registerFormKey,
                initialValue: {
                  'username': '',
                  'email': '',
                  'password1': '',
                  'password2': '',
                },
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: "username",
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).tr('register.username_label'),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: AppLocalizations.of(context).tr('register.username_required_text'),
                        ),
                      ],
                      textInputAction: TextInputAction.next,
                      focusNode: usernameFocusNode,
                      onFieldSubmitted: (value) {
                        onFocusChange(context, usernameFocusNode, emailFocusNode);
                      },
                    ),
                    FormBuilderTextField(
                      attribute: "email",
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).tr('register.email_label'),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: AppLocalizations.of(context).tr('register.email_required_text'),
                        ),
                        FormBuilderValidators.email(
                          errorText: AppLocalizations.of(context).tr('register.email_format_text'),
                        ),
                      ],
                      textInputAction: TextInputAction.next,
                      focusNode: emailFocusNode,
                      onFieldSubmitted: (value) {
                        onFocusChange(context, emailFocusNode, password1FocusNode);
                      },
                    ),
                    FormBuilderTextField(
                      attribute: "password1",
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).tr('register.password1_label'),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: AppLocalizations.of(context).tr('register.password1_required_text'),
                        ),
                        FormBuilderValidators.minLength(
                          8,
                          errorText: AppLocalizations.of(context).tr('register.password1_min_text'),
                        ),
                      ],
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      maxLines: 1,
                      focusNode: password1FocusNode,
                      onFieldSubmitted: (value) {
                        onFocusChange(context, password1FocusNode, password2FocusNode);
                      },
                    ),
                    FormBuilderTextField(
                      attribute: "password2",
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).tr('register.password2_label'),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: AppLocalizations.of(context).tr('register.password2_required_text'),
                        ),
                      ],
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      maxLines: 1,
                      focusNode: password2FocusNode,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      return createRegisterButton(state);
                    }
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    onPressed: onReset,
                    child: Text(
                      AppLocalizations.of(context).tr('register.reset_button'),
                    ),
                    textColor: Colors.white,
                    color: Colors.teal[400],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).tr('register.already_account'),
                  ),
                  FlatButton(
                    onPressed: onLogin,
                    child: Text(
                      AppLocalizations.of(context).tr('register.login_button'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget createRegisterButton(RegisterState state) {
    Widget displayWidget = Text(
      AppLocalizations.of(context).tr('register.register_button'),
    );

    if (state is RegisterFetchingState) {
      displayWidget = Container(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    
    return RaisedButton(
      onPressed: state is RegisterFetchingState ? () {} : onRegister,
      child: displayWidget,
      textColor: Colors.white,
      color: Colors.teal[400],
    );
  }

  @override
  void dispose() {
    super.dispose();
    registerBloc.close();
  }
}