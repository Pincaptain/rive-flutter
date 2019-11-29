import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:rive_flutter/pages/login.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/blocs/register_context.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc.dart';
import 'package:rive_flutter/pages/account.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  RegisterContext registerContext;

  final GlobalKey<FormBuilderState> registerFormKey = GlobalKey<FormBuilderState>();

  RegisterPageState() {
    registerContext = RegisterContext();

    initStreams();
  }

  void initStreams() {
    registerContext.registerBloc.state.listen(onRegisterResult);
  }

  void onRegisterResult(RegisterData registerData) {
    if (registerData.isInitial()) {
      return;
    }

    if (registerData.isValid()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    } else {
      var errorMessage;

      if (registerData.errorsModel.usernameErrors != null) {
        errorMessage = registerData.errorsModel.usernameErrors.first;
      } else if (registerData.errorsModel.emailErrors != null) {
        errorMessage = registerData.errorsModel.emailErrors.first;
      } else if (registerData.errorsModel.password1Errors != null) {
        errorMessage = registerData.errorsModel.password1Errors.first;
      } else if (registerData.errorsModel.password2Errors != null) {
        errorMessage = registerData.errorsModel.password2Errors.first;
      } else if (registerData.errorsModel.nonFieldErrors != null) {
        errorMessage = registerData.errorsModel.nonFieldErrors.first;
      } else {
        errorMessage = registerData.errorMessage;
      }

      createErrorFlushbar(errorMessage).show(context);
    }
  }

  void onRegister() {
    if (registerFormKey.currentState.saveAndValidate()) {
      var registerModel = RegisterModel.fromJson(registerFormKey.currentState.value);
      
      registerContext.registerBloc.dispatch(registerModel);
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
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    registerContext.dispose();
  }
}