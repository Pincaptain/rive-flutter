import 'package:flutter/material.dart';

class InviteFriendsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => InviteFriendsState();
}

class InviteFriendsState extends State<InviteFriendsPage>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Get Free Credits'
        ),
      ),
      body:Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset('assets/images/gift_ride.jpg'),
                  SizedBox(height: 20),
                  Text(
                      'GIFT & GET 1 UNLOCK CREDIT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 20),
                  Text(
                      'Invite a friend to Rive, and you\'ll both get 1 free unlock once he or she starts riding.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300
                      )
                  )
                ],
              )
            ],
          )
      ),
      bottomSheet: Container(
        height: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            Text("Share your invite code"),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: (){},
              color: Colors.teal[400],
              textColor: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 5),
                  Text(
                      'TUJFM4K',
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1
                      )
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.share, size: 24.0)
                ],
              ),
            )
          ],
        )
      )
    );
  }
}