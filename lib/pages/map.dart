import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'package:rive_flutter/pages/account.dart';
import 'package:rive_flutter/pages/login.dart';
import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/pages/ride.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/blocs/map_context.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';
import 'package:rive_flutter/blocs/core/ride_bloc.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  MapContext mapContext;

  Flushbar locationPermissionFlushbar;
  Flushbar connectivityFlushbar;

  StreamSubscription connectivitySubscription;

  final CameraPosition initialLocation = CameraPosition(
    target: LatLng(41.995921, 21.431442),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();

    mapContext = MapContext();

    initStreams();
  }

  void initStreams() {
    mapContext.locationPermissionBloc.state.listen(onLocationPermissionResult);
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(onConnectivityResult);
    mapContext.beginRideBloc.state.listen(onBeginRideResult);
  }

  void onLocationPermissionResult(bool permission) {
    if (!permission) {
      locationPermissionFlushbar = createWarningFlushbar('We need your location permission to show scooters on map.');
      locationPermissionFlushbar.show(context);
    } else {
      if (locationPermissionFlushbar != null) {
        locationPermissionFlushbar.dismiss(context);
      }
    }
  }

  void onConnectivityResult(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      connectivityFlushbar = createWarningFlushbar('Internet connection is required to show scooters on map.');
      connectivityFlushbar.show(context);
    } else {
      if (connectivityFlushbar != null) {
        connectivityFlushbar.dismiss(context);
      }
    }
  }

  void onBeginRideResult(RideData rideData) {
    if (rideData.isInitial()) {
      return;
    }

    if (rideData.isValid()) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RidePage(),
        ),
      );
    } else {
      Navigator.of(context).pop();
      switch (rideData.errorType) {
        case RideErrorType.authentication:
          createUserErrorFlushbar(rideData.errorMessage).show(context);
          break;

        default:
          createErrorFlushbar(rideData.errorMessage).show(context);
      }
    }
  }

  void onRide() async {
    String qrCode;

    try {
      qrCode = await BarcodeScanner.scan(); 
    } on PlatformException {
      createErrorFlushbar('Camera permission is required to scan the QR code.').show(context);
    } on FormatException {
      createErrorFlushbar('Incorrect format or nothing was detected. Please try again!').show(context);
    } catch(exception) {
      createErrorFlushbar('An unexpected error occurred while using the scanner. If this problem persists contact support!').show(context);
    }

    if (qrCode != null) {
      showDialog(
        context: context,
        builder: (_) => createBeginRideDialog(qrCode),
      );
    }
  }

  void onRideAccepted(String qrCode) {
    mapContext.beginRideBloc.dispatch(qrCode);
  }

  void onAccount() {
    if (Token.isAuthenticated()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  void onLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
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
            ListTile(
              title: Text('Account'),
              trailing: Icon(
                Icons.account_circle,
                color: Colors.blue,
              ),
              onTap: onAccount,
            ),
            ListTile(
              title: Text('Wallet'),
              trailing: Icon(
                Icons.account_balance_wallet,
                color: Colors.lightGreen,
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: Text('Histroy'),
              trailing: Icon(
                Icons.history,
                color: Colors.teal,
                
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: Text('Parked or Not'),
              trailing: Icon(
                Icons.local_parking,
                color: Colors.yellow,
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: Text('Settings'),
              trailing: Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: Text('Help'),
              trailing: Icon(
                Icons.help,
                color: Colors.orange,
              ),
              onTap: () {
              },
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
        stream: mapContext.scootersBloc.state,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            myLocationEnabled: true,
            markers: mapContext.scootersBloc.toMarkers(snapshot.data),
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

  Flushbar createUserErrorFlushbar(String errorMessage) {
    return Flushbar(
      messageText: Text(
        errorMessage,
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
          'Login Now',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: onLogin,
      ),
    );
  }

  FlareGiffyDialog createBeginRideDialog(String qrCode) {
    return FlareGiffyDialog(
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
      onOkButtonPressed: () {
        onRideAccepted(qrCode);
      },
      buttonOkColor: Colors.teal[400],
      buttonOkText: Text(
        'Ride',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    mapContext.dispose();
    connectivitySubscription.cancel();
  }
}