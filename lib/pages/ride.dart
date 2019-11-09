import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/blocs/ride_context.dart';

class RidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RidePageState();
}

class RidePageState extends State<RidePage> {
  RideContext rideContext;

  final CameraPosition initialLocation = CameraPosition(
    target: LatLng(41.995921, 21.431442),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();

    rideContext = RideContext();

    initStreams();
  }

  void initStreams() {
    rideContext.endRideBloc.state.listen(onEndRideResult);
    rideContext.duringRideBloc.state.listen(onDuringRideResult);
  }

  void onEndRide() {
    rideContext.endRideBloc.dispatch(RideEvent.end);
  }

  void onDuringRideResult(RideData rideData) {
    if (rideData.isInitial()) {
      return;
    }
    
    print(rideData.ride.scooter.battery);
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
    rideContext.dispose();
  }
}