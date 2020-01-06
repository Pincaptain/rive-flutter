import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import 'package:rive_flutter/blocs/core/scooters_bloc_events.dart';

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

  var isScanning = false;

  @override
  void initState() {
    super.initState();

    locationPermissionBloc = LocationPermissionBloc();
    beginRideBloc = BeginRideBloc();

    rideStatusBloc = RideStatusBloc();
    rideStatusBloc.add(RideStatusCheckEvent());

    scootersBloc = ScootersBloc();
    scootersBloc.add(ScootersListEvent());

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
      connectivityFlushbar = createWarningFlushbar(AppLocalizations.of(context).tr('map.connection_required'));
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
          createWarningFlushbar(AppLocalizations.of(context).tr('map.location_permission_required'));
      locationPermissionFlushbar.show(context);
    } else {
      if (locationPermissionFlushbar != null) {
        locationPermissionFlushbar.dismiss(context);
      }
    }
  }

  void onBeginRideResult(BeginRideState state) {
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
    if (isScanning) {
      return;
    }

    String qrCode;

    try {
      isScanning = true;
      qrCode = await BarcodeScanner.scan();
    } on PlatformException {
      createErrorFlushbar(AppLocalizations.of(context).tr('map.camera_permission_required')).show(context);
    } on FormatException {
      createErrorFlushbar(AppLocalizations.of(context).tr('map.qr_incorrect_format')).show(context);
    } catch(exc) {
      createErrorFlushbar(AppLocalizations.of(context).tr('map.qr_unexpected')).show(context);
    } finally {
      isScanning = false;
    }

    if (qrCode != null) {
      showDialog(
        context: context,
        builder: (_) => createBeginRideDialog(qrCode),
      );
    }
  }

  void onRideAccepted(String qrCode) {
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScootersBloc>(
          create: (context) => scootersBloc,
        ),
        BlocProvider<BeginRideBloc>(
          create: (context) => beginRideBloc,
        )
      ],
      child: Scaffold(
        drawer: DrawerWidget(context),
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('map.title'),
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
              tooltip: AppLocalizations.of(context).tr('map.localization_button'),
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: BlocBuilder<ScootersBloc, ScootersState>(
          condition: (prevState, state) {
            if (state is ScootersSuccessState) {
              if (scootersBloc.prevSuccessState == null) {
                scootersBloc.prevSuccessState = state;

                return true;
              } else {
                final condition = state.scooters != scootersBloc.prevSuccessState.scooters;
                scootersBloc.prevSuccessState = state;

                return condition;
              }
            } else {
              return false;
            }
          },
          builder: (context, state) {
            return createGoogleMap(state);
          }
        ),
        floatingActionButton: Container(
          height: 45,
          width: double.infinity,
          margin: EdgeInsets.only(left: 30),
          child: BlocBuilder<BeginRideBloc, BeginRideState>(
            builder: (context, state) {
              return createBeginRideButton(state);
            }
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
          title: '${AppLocalizations.of(context).tr('map.scooter_info_name')}: ${scooter.pk}',
          snippet: '${AppLocalizations.of(context).tr('map.scooter_info_battery')}: ${scooter.battery} %',
        ),
      )).toSet(),
    );
  }

  Widget createBeginRideButton(BeginRideState state) {
    Widget displayWidget = Text(
      AppLocalizations.of(context).tr('map.ride_button'),
      style: TextStyle(
        fontSize: 16,
      ),
    );

    if (state is BeginRideFetchingState) {
      displayWidget = Container(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return RaisedButton(
      onPressed: state is BeginRideFetchingState ? () {} : onRide,
      child: displayWidget,
      color: Colors.teal[400],
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
          AppLocalizations.of(context).tr('map.login_now'),
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
        AppLocalizations.of(context).tr('map.qr_success_title'),
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600
        ),
      ),
      description: Text(
        AppLocalizations.of(context).tr('map.qr_success_description'),
        textAlign: TextAlign.center,
      ),
      onOkButtonPressed: () {
        onRideAccepted(qrCode);
      },
      buttonOkColor: Colors.teal[400],
      buttonOkText: Text(
        AppLocalizations.of(context).tr('map.confirm_ride_button'),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      buttonCancelText: Text(
        AppLocalizations.of(context).tr('map.cancel_ride_button'),
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