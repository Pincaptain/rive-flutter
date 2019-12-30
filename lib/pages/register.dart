import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loading_overlay/loading_overlay.dart';

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

  RegisterBloc registerBloc;

  var isLoading = false;

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
    if (state is RegisterUninitializedState || state is RegisterFetchingState) {
      return;
    } else if (state is RegisterSuccessState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    } else if (state is RegisterErrorState) {
      createErrorFlushbar(state.errorMessage).show(context);
    }

    setLoading(false);
  }

  void onRegister() {
    setLoading(true);

    if (registerFormKey.currentState.saveAndValidate()) {
      final registerModel = RegisterModel.fromJson(registerFormKey.currentState.value);

      registerBloc.add(RegisterEvent(
        registerModel: registerModel,
      ));
    } else {
      setLoading(false);
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

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      progressIndicator: CircularProgressIndicator(),
      opacity: 0.3,
      isLoading: isLoading,
      color: Colors.teal[400],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Register'
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
                      decoration: InputDecoration(labelText: "Username"),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(70)
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "email",
                      decoration: InputDecoration(labelText: "Email"),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "password1",
                      decoration: InputDecoration(labelText: "Password", ),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(8),
                        FormBuilderValidators.maxLength(32)
                      ],
                      obscureText: true,
                      maxLines: 1,
                    ),
                    FormBuilderTextField(
                      attribute: "password2",
                      decoration: InputDecoration(labelText: "Verify Password", ),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(8),
                        FormBuilderValidators.maxLength(32)
                      ],
                      obscureText: true,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: onRegister,
                    child: Text("Register"),
                    textColor: Colors.white,
                    color: Colors.teal[400],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    onPressed: onReset,
                    child: Text("Reset"),
                    textColor: Colors.white,
                    color: Colors.teal[400],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Already have an accout?'
                  ),
                  FlatButton(
                    onPressed: onLogin,
                    child: Text(
                      'Login now!',
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

  @override
  void dispose() {
    super.dispose();
    registerBloc.close();
  }
}