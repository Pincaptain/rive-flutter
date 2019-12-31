import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'package:rive_flutter/pages/login.dart';
import 'package:rive_flutter/pages/invite_friends.dart';
import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/pages/ride.dart';
import 'package:rive_flutter/widgets/builders/flushbar_builders.dart';
import 'package:rive_flutter/widgets/extensions/drawer.dart';
import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_events.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_states.dart';
import 'package:rive_flutter/blocs/core/scooters_bloc.dart';
import 'package:rive_flutter/blocs/core/scooters_bloc_states.dart';
import 'package:rive_flutter/blocs/extensions/location_bloc.dart';
import 'package:rive_flutter/blocs/extensions/location_bloc_states.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final initialLocation = CameraPosition(
    target: LatLng(41.995921, 21.431442),
    zoom: 16,
  );

  LocationPermissionBloc locationPermissionBloc;
  BeginRideBloc beginRideBloc;
  RideStatusBloc rideStatusBloc;
  ScootersBloc scootersBloc;
  StreamSubscription connectivitySubscription;

  Flushbar locationPermissionFlushbar;
  Flushbar connectivityFlushbar;

  var isLoading = false;

  @override
  void initState() {
    super.initState();

    locationPermissionBloc = LocationPermissionBloc();
    beginRideBloc = BeginRideBloc();
    rideStatusBloc = RideStatusBloc();
    scootersBloc = ScootersBloc();

    initStreams();
  }

  void initStreams() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(onConnectivityResult);
    locationPermissionBloc.listen(onLocationPermissionResult);
    beginRideBloc.listen(onBeginRideResult);
    rideStatusBloc.listen(onRideStatusResult);
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

  void onLocationPermissionResult(LocationPermissionState state) {
    if (state is LocationPermissionDisallowedState) {
      locationPermissionFlushbar =
          createWarningFlushbar('We need your location permission to show scooters on map.');
      locationPermissionFlushbar.show(context);
    } else {
      if (locationPermissionFlushbar != null) {
        locationPermissionFlushbar.dismiss(context);
      }
    }
  }

  void onBeginRideResult(BeginRideState state) {
    if (state is BeginRideUninitializedState || state is BeginRideFetchingState) {
      return;
    }

    if (state is BeginRideSuccessState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RidePage(),
        ),
      );
    } else if (state is BeginRideUnauthorizedState) {
      createUserErrorFlushbar(state.errorMessage).show(context);
    } else if (state is BeginRideErrorState) {
      createErrorFlushbar(state.errorMessage).show(context);
    }

    setLoading(false);
  }

  void onRideStatusResult(RideStatusState state) {
    if (state is RideStatusInRideState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RidePage(),
        ),
      );
    }
  }

  void onRide() async {
    setLoading(true);

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

    setLoading(false);
    if (qrCode != null) {
      showDialog(
        context: context,
        builder: (_) => createBeginRideDialog(qrCode),
      );
    }
  }

  void onRideAccepted(String qrCode) {
    setLoading(true);
    Navigator.of(context).pop();
    beginRideBloc.add(BeginRideEvent(
      qrCode: qrCode,
    ));
  }

  void onLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScootersBloc>(
      create: (context) => scootersBloc,
      child: LoadingOverlay(
        progressIndicator: CircularProgressIndicator(),
        color: Colors.teal[400],
        opacity: 0.3,
        isLoading: isLoading,
        child: Scaffold(
          drawer: DrawerWidget(context),
          appBar: AppBar(
            title: Text(
              'Rive'
            ),
          ),
          body: BlocBuilder<ScootersBloc, ScootersState>(
            builder: (context, state) {
              return createGoogleMap(state);
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
        ),
      ),
    );
  }

  Widget createGoogleMap(ScootersState state) {
    var scooters = List<Scooter>();

    if (state is ScootersSuccessState) {
      scooters = state.scooters;
    }

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: initialLocation,
      myLocationEnabled: true,
      markers: scootersBloc.toMarkers(scooters),
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
    locationPermissionBloc.close();
    beginRideBloc.close();
    rideStatusBloc.close();
    scootersBloc.close();
    connectivitySubscription.cancel();
  }
}