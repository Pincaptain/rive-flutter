import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:rive_flutter/blocs/map_bloc.dart';
import 'package:rive_flutter/models/auth.dart';

class EndRideBloc extends Bloc<RideData, bool> {
  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(RideData rideData) {
    return getEndRideData(rideData).asStream();
  }

  Future<bool> getEndRideData(RideData rideData) async {
    var response = await http.get(
      Uri.encodeFull(Client.client + 'api/scooters/${rideData.scooter.pk}/end_ride'),
      headers: {
        'Authorization': Token.getHeaderToken(),
      },
    );

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }
}

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
  EndRideBloc endRideBloc;

  RideBloc() {
    speedBloc = SpeedBloc();
    endRideBloc = EndRideBloc();
  }

  void dispose() {
    speedBloc.dispose();
    endRideBloc.dispose();
  }
}