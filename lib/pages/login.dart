import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:rive_flutter/pages/register.dart';
import 'package:rive_flutter/blocs/login_context.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/blocs/auth/auth_bloc.dart';
import 'package:rive_flutter/pages/account.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginContext loginContext;

  bool isLoading = false;

  final GlobalKey<FormBuilderState> loginFormKey = GlobalKey<FormBuilderState>();

  LoginPageState() {
    loginContext = LoginContext();

    initStreams();
  }

  void initStreams() {
    loginContext.loginBloc.state.listen(onLoginResult);
  }

  void onLoginResult(LoginData loginData) {
    if (loginData.isInitial()) {
      return;
    }

    if (loginData.isValid()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    } else {
      createErrorFlushbar(loginData.errorMessage).show(context);
    }

    setLoading(false);
  }

  void onLogin() {
    setLoading(true);

    if (loginFormKey.currentState.saveAndValidate()) {
      var loginModel = LoginModel.fromJson(loginFormKey.currentState.value);
      
      loginContext.loginBloc.dispatch(loginModel);
    } else {
      setLoading(false);
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

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      color: Colors.teal,
      opacity: 0.3,
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login'
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
                      decoration: InputDecoration(labelText: "Username"),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "password",
                      decoration: InputDecoration(labelText: "Password", ),
                      validators: [
                        FormBuilderValidators.required(),
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
                    onPressed: onLogin,
                    child: Text("Login"),
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
                    'Don\'t have an account?'
                  ),
                  FlatButton(
                    onPressed: onRegister,
                    child: Text(
                      'Register now!',
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

  @override
  void dispose() {
    super.dispose();
    loginContext.dispose();
  }
}