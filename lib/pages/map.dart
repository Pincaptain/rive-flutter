import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';

import 'package:rive_flutter/blocs/map_bloc.dart';
import 'package:rive_flutter/models/core.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  MapBloc mapBloc;

  Flushbar locationPermissionFlushbar;
  Flushbar connectivityFlushbar;

  StreamSubscription connectivitySubscription;

  final CameraPosition initialLocation = CameraPosition(
    target: LatLng(41.995921, 21.431442),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();

    mapBloc = MapBloc();
    locationPermissionFlushbar = Flushbar(
      messageText: Text(
        'We need your location permission to show scooters on map.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      isDismissible: false,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      aroundPadding: EdgeInsets.all(8),
      borderRadius: 8,
    );
    connectivityFlushbar = Flushbar(
      messageText: Text(
        'Internet connection is required to show scooters on map.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      isDismissible: false,
      icon: Icon(
        Icons.warning,
        color: Colors.white,
      ),
      aroundPadding: EdgeInsets.all(8),
      borderRadius: 8,
    );

    initStreams();
  }

  void initStreams() {
    mapBloc.locationPermissionBloc.state.listen(onLocationPermissionResult);
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(onConnectivityResult);
  }

  void onLocationPermissionResult(bool permission) {
    if (!permission) {
      locationPermissionFlushbar.show(context);
    } else {
      if (locationPermissionFlushbar != null) {
        locationPermissionFlushbar.dismiss(context);
      }
    }
  }

  void onConnectivityResult(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      connectivityFlushbar.show(context);
    } else {
      if (connectivityFlushbar != null) {
        connectivityFlushbar.dismiss(context);
      }
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: FlareActor(
                    'assets/images/Scooter.flr'
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Text(
          'Rive'
        ),
      ),
      body: StreamBuilder<List<Scooter>>(
        stream: mapBloc.scooterBloc.state,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            myLocationEnabled: true,
            markers: mapBloc.toMarkers(snapshot.data),
          );
        }
      ),
      floatingActionButton: Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.only(left: 30),
        child: RaisedButton(
          onPressed: () {},
          child: Text(
            'Drive',
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
    mapBloc.dispose();
    connectivitySubscription.cancel();
  }
}