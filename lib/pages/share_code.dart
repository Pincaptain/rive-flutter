import 'package:flutter/material.dart';

import 'package:share/share.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rive_flutter/blocs/core/share_code_bloc.dart';
import 'package:rive_flutter/blocs/core/share_code_bloc_events.dart';
import 'package:rive_flutter/blocs/core/share_code_bloc_states.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';

class ShareCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShareCodePageState();
}

class ShareCodePageState extends State<ShareCodePage> {
  ShareCodeBloc shareCodeBloc;

  @override
  void initState() {
    super.initState();

    shareCodeBloc = ShareCodeBloc();
    shareCodeBloc.add(GetShareCodeEvent());

    initListeners();
  }

  void initListeners() {
    shareCodeBloc.listen(onShareCodeError);
  }

  void onShareCodeError(ShareCodeState state) {
    if (state is ShareCodeErrorState) {
      createErrorFlushbar(state.errorMessage).show(context);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShareCodeBloc>(
        create: (context) => shareCodeBloc,
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
            bottomSheet: BlocBuilder<ShareCodeBloc, ShareCodeState>(
                builder: (context, state) {
              return createShareCodeButton(state);
            })));
  }

  Widget createShareCodeButton(ShareCodeState state) {
    var displayText = '';
    if (state is ShareCodeFetchingState) {
      displayText = 'Waiting...';
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is ShareCodeSuccessState) {
      displayText = state.code;
    } else {
      //should not happen
      displayText = 'Unexpected error';
    }

    return Container(
        height: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: <Widget>[
          Text(
            'Share your invite code',
            style: TextStyle(
              color: Colors.teal[400],
            ),
          ),
          SizedBox(height: 10),
          RaisedButton(
              onPressed: () {
                if (state is ShareCodeSuccessState) {
                  Share.share(
                      'Get a free begin ride here! \n ${Client.client}/api/share_code/${state.code}');
                }
              },
              color: Colors.teal[400],
              textColor: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 5),
                    Text(displayText,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                    SizedBox(width: 5),
//                    Container(
//                        child: (state is ShareCodeSuccessState)
//                            ? Icon(Icons.share, size: 24.0)
//                            : null)
                  ]))
        ]));
  }

  @override
  void dispose() {
    super.dispose();
    shareCodeBloc.close();
  }
}
