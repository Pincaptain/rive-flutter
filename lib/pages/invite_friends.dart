import 'package:flutter/material.dart';


import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive_flutter/blocs/core/invite_friends_bloc.dart';
import 'package:rive_flutter/blocs/core/invite_friends_bloc_states.dart';

class InviteFriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InviteFriendsPageState();
}

class InviteFriendsPageState extends State<InviteFriendsPage> {
  InviteFriendsBloc inviteFriendsBloc;

  @override
  void initState() {
    super.initState();

    inviteFriendsBloc = InviteFriendsBloc();
//    historyBloc.add(HistoryPaginatedEvent());
//    inviteFriendsBloc.add()
//
//    initListeners();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InviteFriendsBloc>(
        create: (context) => inviteFriendsBloc,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Get Free Credits'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: 350,
                          height: 250,
                          child: FlareActor(
                            'assets/images/Giftbox.flr',
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'GIFT & GET 1 UNLOCK CREDIT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.teal[400],
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            child: Text(
                          'Invite a friend to Rive, and you\'ll both get 1 free unlock once he or she starts riding.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.teal[400],
                          ),
                        ))
                      ],
                    )
                  ],
                )),
            bottomSheet: Container(
                height: 100,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Share your invite code',
                      style: TextStyle(
                        color: Colors.teal[400],
                      ),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      onPressed: () {},
                      color: Colors.teal[400],
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 5),
                          Text('TUJFM4K',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1)),
                          SizedBox(width: 5),
                          Icon(Icons.share, size: 24.0)
                        ],
                      ),
                    )
                  ],
                ))));
  }
  Widget showShareCode(InviteFriendsState state){
    if(state is ShareCodeSuccessState) {
     return Text('$state.code');
    }else if(state is ShareCodeSuccessState)
  }
}
