import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'package:rive_flutter/blocs/map_bloc.dart';
import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/pages/ride.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  MapBloc mapBloc;

  Flushbar locationPermissionFlushbar;
  Flushbar connectivityFlushbar;
  Flushbar scannerPlatformFlushbar;
  Flushbar scannerFormatFlushbar;
  Flushbar scannerUnknownFlushbar;
  Flushbar invalidQrFlushbar;
  Flushbar invalidUserFlushbar;

  FlareGiffyDialog rideDialog;

  StreamSubscription connectivitySubscription;

  RideData rideData;

  final CameraPosition initialLocation = CameraPosition(
    target: LatLng(41.995921, 21.431442),
    zoom: 16,
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
      margin: EdgeInsets.all(8),
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
      margin: EdgeInsets.all(8),
      borderRadius: 8,
    );
    scannerPlatformFlushbar = Flushbar(
      messageText: Text(
        'Camera permission is required to scan the QR code.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    );
    scannerFormatFlushbar = Flushbar(
      messageText: Text(
        'Incorrect format or nothing was detected. Please try again!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    );
    scannerUnknownFlushbar = Flushbar(
      messageText: Text(
        'Unknown exception. Please contact the developers!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    );
    invalidQrFlushbar = Flushbar(
      messageText: Text(
        'Invalid scooter identification code or scooter already rented. Please try again!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    );
    invalidUserFlushbar = Flushbar(
      messageText: Text(
        'You need an active account to begin a ride.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.teal,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
      mainButton: FlatButton(
        child: Text(
          'Register Now',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {},
      ),
    );

    rideDialog = FlareGiffyDialog(
      flarePath: 'assets/images/BarcodeSuccess.flr',
      flareAnimation: 'sucsess',
      title: Text(
        'Success',
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600
        ),
      ),
      description: Text(
        'Make sure you want to ride this scooter and proceed by pressing ride. Otherwise press cancel to cancel the ride!',
        textAlign: TextAlign.center,
      ),
      onOkButtonPressed: onRideAccepted,
      buttonOkColor: Colors.teal[400],
      buttonOkText: Text(
        'Ride',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    initStreams();
  }

  void initStreams() {
    mapBloc.locationPermissionBloc.state.listen(onLocationPermissionResult);
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(onConnectivityResult);
    mapBloc.validateRideBloc.state.listen(onValidateRideResult);
    mapBloc.beginRideBloc.state.listen(onBeginRideResult);
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

  void onValidateRideResult(RideData rideData) {
    if (rideData.initial) {
      return;
    }

    if (rideData.valid()) {
      this.rideData = rideData;

      showDialog(
        context: context,
        builder: (_) => rideDialog,
      );
    } else {
      invalidQrFlushbar.show(context);
    }
  }

  void onBeginRideResult(RideData rideData) {
    if (rideData.initial) {
      return;
    }

    if (rideData.successful()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RidePage(rideData),
        ),
      );
    } else {
      Navigator.of(context).pop();
      invalidUserFlushbar.show(context);
    }
  }

  void onRide() async {
    String qr;

    try {
      qr = await BarcodeScanner.scan();
    } on PlatformException {
      scannerPlatformFlushbar.show(context);
    } on FormatException {
      scannerFormatFlushbar.show(context);
    } catch(exception) {
      scannerUnknownFlushbar.show(context);
    }

    if (qr != null) {
      mapBloc.validateRideBloc.dispatch(qr);  
    }
  }

  void onRideAccepted() {
    mapBloc.beginRideBloc.dispatch(rideData);
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
          onPressed: onRide,
          child: Text(
            'Ride',
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