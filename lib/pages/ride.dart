import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rive_flutter/blocs/ride_bloc.dart';

class RidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RidePageState();
}

class RidePageState extends State<RidePage> {
  RideBloc rideBloc;

  @override
  void initState() {
    super.initState();

    rideBloc = RideBloc();
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
          'Rive',
        ),
      ),
      body: Center(
        child: StreamBuilder<Object>(
          stream: rideBloc.speedBloc.state,
          builder: (context, snapshot) {
            return Text(
              snapshot.data.toString(),
              style: TextStyle(
                fontSize: 22,
              ),
            );
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    rideBloc.dispose();
  }
}