import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';

class SpeedBloc extends Bloc<LocationData, double> {
  @override
  double get initialState => 0;

  StreamSubscription locationSubscription;

  SpeedBloc() {
    initStreams();
  }

  @override
  Stream<double> mapEventToState(LocationData event) async* {
    if (event.speed == 0) {
      yield 0;
    }
    
    yield event.speed * 3600 / 1000;
  }

  void initStreams() {
    locationSubscription = Location().onLocationChanged().listen(onLocation);
  }

  void onLocation(LocationData locationData) {
    dispatch(locationData);
  }

  @override
  void dispose() {
    super.dispose();
    locationSubscription.cancel();
  }

}

class RideBloc {
  SpeedBloc speedBloc;

  RideBloc() {
    speedBloc = SpeedBloc();
  }

  void dispose() {
    speedBloc.dispose();
  }
}