import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

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

  RideBloc rideBloc;
  EndRideBloc endRideBloc;
  StreamSubscription endRideSubscription;

  @override
  void initState() {
    super.initState();

    rideBloc = RideBloc();
    rideBloc.add(RideCheckEvent());

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
  }

  void onEndRide() {
    endRideBloc.add(EndRideEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RideBloc>(
          create: (context) => rideBloc,
        ),
        BlocProvider<EndRideBloc>(
          create: (context) => endRideBloc,
        ),
      ],
      child: Scaffold(
        drawer: DrawerWidget(context),
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).tr('ride.title'),
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
          child: BlocBuilder<EndRideBloc, EndRideState>(
            builder: (context, state) {
              return createEndRideButton(state);
            },
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
      return Container(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
      );
    } else if (state is RideErrorState) {
      return Icon(
        Icons.battery_alert,
        color: Colors.white,
      );
    } else {
      RideSuccessState successState = state as RideSuccessState;
      final battery = successState.ride.scooter.battery != 0 ?
        successState.ride.scooter.battery / 100 :
        0.0;
      Color batteryPercentageColor;

      if (battery >= 0.60) {
        batteryPercentageColor = Colors.white;
      } else if (battery <= 0.40) {
        batteryPercentageColor = Colors.teal[400];
      } else {
        batteryPercentageColor = Colors.teal[900];
      }

      return LiquidCircularProgressIndicator(
        value: battery,
        valueColor: AlwaysStoppedAnimation(Colors.teal[400]),
        backgroundColor: Colors.white,
        center: Text(
          '${successState.ride.scooter.battery.toString()}',
          style: TextStyle(
            color: batteryPercentageColor,
          ),
        ),
      );
    }
  }

  Widget createEndRideButton(EndRideState state) {
    Widget displayWidget = Text(
      AppLocalizations.of(context).tr('ride.end_ride'),
      style: TextStyle(
        fontSize: 16,
      ),
    );

    if (state is EndRideFetchingState) {
      displayWidget = Container(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
      );
    }

    return RaisedButton(
      onPressed: state is EndRideFetchingState ? () {} : onEndRide,
      child: displayWidget,
      color: Colors.teal[400],
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    rideBloc.close();
    endRideBloc.close();
    endRideSubscription.cancel();
  }
}