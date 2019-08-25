import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:rive_flutter/blocs/map_bloc.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/models/core.dart';

class DuringRideBloc extends Bloc<RideData, RideData> {
  DuringRideBloc(this.rideData) {
    rideDataTimer = Timer.periodic(Duration(seconds: 5), dispatchRideData);
  }

  final RideData rideData;
  Timer rideDataTimer;

  @override
  RideData get initialState => rideData;

  @override
  Stream<RideData> mapEventToState(RideData rideData) {
    return getRideData(rideData).asStream();
  }

  void dispatchRideData(Timer rideDataTimer) {
    dispatch(rideData);
  }

  Future<RideData> getRideData(RideData rideData) async {
    rideData.scooter = await getScooter(rideData.scooter.pk.toString());

    return rideData;
  }

  Future<Scooter> getScooter(String id) async {
    var response = await http.get(
      Uri.encodeFull(Client.client + 'api/scooters/' + id),
    );

    if (response.statusCode != 200) {
      return null;
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var scooter = Scooter.fromJson(jsonData);

    return scooter;
  }

  @override
  void dispose() {
    super.dispose();
    rideDataTimer.cancel();
  }
}

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
  Stream<double> mapEventToState(LocationData locationData) async* {
    if (locationData.speed == 0) {
      yield 0;
    }
    
    yield locationData.speed * 3600 / 1000;
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
  DuringRideBloc duringRideBloc;
  EndRideBloc endRideBloc;

  RideBloc() {
    speedBloc = SpeedBloc();
    duringRideBloc = DuringRideBloc();
    endRideBloc = EndRideBloc();
  }

  void dispose() {
    speedBloc.dispose();
    duringRideBloc.dispose();
    endRideBloc.dispose();
  }
}