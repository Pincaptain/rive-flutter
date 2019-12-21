import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/blocs/ride_context.dart';
import 'package:rive_flutter/pages/review.dart';

class RidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RidePageState();
}

class RidePageState extends State<RidePage> {
  RideContext rideContext;

  bool isLoading = false;

  StreamSubscription<bool> endRideSubscription;

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
    endRideSubscription = rideContext.endRideBloc.state.listen(onEndRideResult);
  }

  void onEndRideResult(bool rideResult) {
    if (rideResult) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewPage(),
        ),
      );
    }

    setLoading(false);
  }

  void onEndRide() {
    setLoading(true);
    rideContext.endRideBloc.dispatch(RideEvent.end);
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      color: Colors.teal[400],
      progressIndicator: CircularProgressIndicator(),
      isLoading: isLoading,
      opacity: 0.3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Rive',
          ),
        ),
        body: StreamBuilder<RideData>(
          stream: rideContext.duringRideBloc.state,
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: initialLocation,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: FloatingActionButton(
                      onPressed: null,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.teal[400],
                      child: Text(
                        snapshot.hasData ?
                          snapshot.data.ride.scooter.battery.toString() :
                          '?'
                      )
                    ),
                  ),
                ),
              ],
            );
          }
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    rideContext.dispose();
    endRideSubscription.cancel();
  }
}