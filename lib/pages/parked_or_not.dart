import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';

class ParkedOrNotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ParkedOrNotPageState();
}

class ParkedOrNotPageState extends State<ParkedOrNotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Parked Or Not'
        ),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              width: 350,
              height: 350,
              child: FlareActor(
                'assets/images/Error.flr',
              ),
            ),
          ),
          Center(
            child: Text(
              'Under Development',
              style: TextStyle(
                color: Colors.teal[400],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              child: Text(
                'Use the back icon near the app bar to return to map.',
                style: TextStyle(
                  color: Colors.teal[400],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}