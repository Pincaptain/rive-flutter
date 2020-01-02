import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

import 'package:rive_flutter/pages/login.dart';
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

  AppLocalizations dict;

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

    dict = AppLocalizations.of(context);

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
      connectivityFlushbar = createWarningFlushbar(dict.tr('map.connection_required'));
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
          createWarningFlushbar(dict.tr('map.location_permission_required'));
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
      createErrorFlushbar(dict.tr('map.camera_permission_required')).show(context);
    } on FormatException {
      createErrorFlushbar(dict.tr('map.qr_incorrect_format')).show(context);
    } catch(exc) {
      createErrorFlushbar(dict.tr('map.qr_unexpected')).show(context);
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
              dict.tr('map.title'),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  if (EasyLocalizationProvider.of(context).data.locale == Locale('en', 'US')) {
                    EasyLocalizationProvider.of(context).data.changeLocale(Locale('mk', 'MK'));
                  } else {
                    EasyLocalizationProvider.of(context).data.changeLocale(Locale('en', 'US'));
                  }
                },
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
              )
            ],
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
                dict.tr('map.ride_button'),
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
      markers: scooters.map((scooter) => Marker(
        markerId: MarkerId(scooter.pk.toString()),
        position: LatLng(scooter.latitude, scooter.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(scooter.battery.toDouble()),
        infoWindow: InfoWindow(
          title: '${dict.tr('map.scooter_info_name')}: ${scooter.pk}',
          snippet: '${dict.tr('map.scooter_info_battery')}: ${scooter.battery} %',
        ),
      )).toSet(),
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
          dict.tr('map.login_now'),
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
        dict.tr('map.qr_success_title'),
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600
        ),
      ),
      description: Text(
        dict.tr('map.qr_success_description'),
        textAlign: TextAlign.center,
      ),
      onOkButtonPressed: () {
        onRideAccepted(qrCode);
      },
      buttonOkColor: Colors.teal[400],
      buttonOkText: Text(
        dict.tr('map.confirm_ride_button'),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      buttonCancelText: Text(
        dict.tr('map.cancel_ride_button'),
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