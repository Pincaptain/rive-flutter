import 'package:flutter/material.dart';

import 'package:share/share.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rive_flutter/blocs/core/share_code_bloc.dart';
import 'package:rive_flutter/blocs/core/share_code_bloc_events.dart';
import 'package:rive_flutter/blocs/core/share_code_bloc_states.dart';
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
    shareCodeBloc.add(ShareCodeGetEvent());

    initStreams();
  }

  void initStreams() {
    shareCodeBloc.listen(onShareCodeResult);
  }

  void onShareCodeResult(ShareCodeState state) {
    if (state is ShareCodeErrorState) {
      createErrorFlushbar(state.errorMessage).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShareCodeBloc>(
      create: (context) => shareCodeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr("share_code.title")),
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
                    AppLocalizations.of(context).tr("share_code.share_code_title"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.teal[400],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      AppLocalizations.of(context).tr("share_code.share_code_description"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.teal[400],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          height: 100,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: <Widget>[
              Text(
                AppLocalizations.of(context).tr("share_code.share_code_invite"),
                style: TextStyle(
                  color: Colors.teal[400],
                ),
              ),
              SizedBox(height: 10),
              BlocBuilder<ShareCodeBloc, ShareCodeState>(
                builder: (context, state) {
                  return createShareCodeButton(state);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createShareCodeButton(ShareCodeState state) {
    Widget displayWidget = Container(
      height: 12.0,
      width: 12.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );

    if (state is ShareCodeSuccessState) {
      displayWidget = Text(
        state.shareCode.code,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w900,
          letterSpacing: 1
        ),
      );
    } else if (state is ShareCodeErrorState) {
      displayWidget = Icon(
        Icons.error_outline,
        color: Colors.white,
      );
    }

    return RaisedButton(
      onPressed: () {
        if (state is ShareCodeSuccessState) {
          Share.share(
            '${AppLocalizations.of(context).tr("share_code.share_code_share")}\n${state.shareCode.code}'
          );
        } else if (state is ShareCodeErrorState) {
          createErrorFlushbar(state.errorMessage).show(context);
        }
      },
      color: Colors.teal[400],
      textColor: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: displayWidget,
    );
  }

  @override
  void dispose() {
    super.dispose();
    shareCodeBloc.close();
  }
}