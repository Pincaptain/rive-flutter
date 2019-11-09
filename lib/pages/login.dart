import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> loginFormKey = GlobalKey<FormBuilderState>();
  
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
          'Rive'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: loginFormKey,
              initialValue: {
                'date': DateTime.now(),
                'accept_terms': false,
              },
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "username",
                    decoration: InputDecoration(labelText: "Username"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(70),
                    ],
                  ),
                  FormBuilderTextField(
                    attribute: "password",
                    decoration: InputDecoration(labelText: "Password"),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                MaterialButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (loginFormKey.currentState.saveAndValidate()) {
                      print(loginFormKey.currentState.value);
                    }
                  },
                ),
                MaterialButton(
                  child: Text("Reset"),
                  onPressed: () {
                    loginFormKey.currentState.reset();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}