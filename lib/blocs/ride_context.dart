import 'package:rive_flutter/blocs/core/ride_bloc.dart';
import 'package:rive_flutter/blocs/extensions/location_bloc.dart';

class RideContext {
  SpeedBloc speedBloc;
  RideBloc duringRideBloc;
  EndRideBloc endRideBloc;

  RideContext() {
    speedBloc = SpeedBloc();
    duringRideBloc = RideBloc();
    endRideBloc = EndRideBloc();
  }

  void dispose() {
    speedBloc.dispose();
    duringRideBloc.dispose();
    endRideBloc.dispose();
  }
}