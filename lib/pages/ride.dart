import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_dialog/easy_dialog.dart';

import 'package:rive_flutter/blocs/ride_bloc.dart';
import 'package:rive_flutter/blocs/map_bloc.dart';

class RidePage extends StatefulWidget {
  final RideData rideData;

  RidePage(this.rideData);

  @override
  State<StatefulWidget> createState() => RidePageState(rideData);
}

class RidePageState extends State<RidePage> {
  final RideData rideData;

  RideBloc rideBloc;

  final CameraPosition initialLocation = CameraPosition(
    target: LatLng(41.995921, 21.431442),
    zoom: 16,
  );

  EasyDialog reviewDialog;

  RidePageState(this.rideData);

  @override
  void initState() {
    super.initState();

    rideBloc = RideBloc(rideData);

    reviewDialog = EasyDialog();

    initStreams();
  }

  void initStreams() {
    rideBloc.endRideBloc.state.listen(onEndRideResult);
    rideBloc.duringRideBloc.state.listen(onDuringRideResult);
  }

  void onEndRide() {
    rideBloc.endRideBloc.dispatch(rideData);
  }

  void onDuringRideResult(RideData rideData) {
    print(rideData.scooter.battery);
  }

  void onEndRideResult(bool rideResult) {
    if (rideResult) {
      Navigator.of(context).pop();
    }
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
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: initialLocation,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.only(left: 30),
        child: RaisedButton(
          onPressed: onEndRide,
          child: Text(
            'End Ride',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          color: Colors.teal[400],
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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