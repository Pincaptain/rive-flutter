import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    zoom: 14.4746,
  );

  RidePageState(this.rideData);

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
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: initialLocation,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    rideBloc.dispose();
  }
}