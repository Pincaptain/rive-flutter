import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_events.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_states.dart';
import 'package:rive_flutter/pages/review.dart';
import 'package:rive_flutter/widgets/extensions/drawer.dart';

class RidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RidePageState();
}

class RidePageState extends State<RidePage> {
  final initialLocation = CameraPosition(
    target: LatLng(41.995921, 21.431442),
    zoom: 16,
  );

  AppLocalizations dict;

  RideBloc rideBloc;

  EndRideBloc endRideBloc;
  StreamSubscription endRideSubscription;

  var isLoading = false;

  @override
  void initState() {
    super.initState();

    dict = AppLocalizations.of(context);

    rideBloc = RideBloc();
    endRideBloc = EndRideBloc();

    initStreams();
  }

  void initStreams() {
    endRideSubscription = endRideBloc.listen(onEndRideResult);
  }

  void onEndRideResult(EndRideState endRideState) {
    if (endRideState is EndRideUninitializedState) {
      return;
    }
    else if (endRideState is EndRideSuccessState) {
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
    endRideBloc.add(EndRideEvent());
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RideBloc>(
      create: (context) => rideBloc,
      child: LoadingOverlay(
        color: Colors.teal[400],
        progressIndicator: CircularProgressIndicator(),
        isLoading: isLoading,
        opacity: 0.3,
        child: Scaffold(
          drawer: DrawerWidget(context),
          appBar: AppBar(
            title: Text(
              dict.tr('ride.title'),
            ),
          ),
          body: BlocBuilder<RideBloc, RideState>(
            builder: (context, state) {
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
                        child: createBatteryIndicator(state),
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
                dict.tr('ride.end_ride'),
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

  Widget createBatteryIndicator(RideState state) {
    if (state is RideUninitializedState) {
      return Icon(
        Icons.battery_unknown,
        color: Colors.white,
      );
    } else if (state is RideFetchingState) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else if (state is RideErrorState) {
      return Icon(
        Icons.battery_alert,
        color: Colors.white,
      );
    } else {
      RideSuccessState successState = state as RideSuccessState;

      return Text(
        successState.ride.scooter.battery.toString(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    rideBloc.close();
    endRideBloc.close();
    endRideSubscription.cancel();
  }
}