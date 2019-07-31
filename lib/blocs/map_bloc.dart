import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/blocs/splash_bloc.dart';

abstract class ScooterEvent {
  Future<List<Scooter>> onEvent();
}

class ListScooterEvent extends ScooterEvent {
  @override
  Future<List<Scooter>> onEvent() async {
    var response = await http.get(
      Uri.encodeFull(Client.client + 'api/scooters/'),
    );

    if (response.statusCode != 200) {
      return List<Scooter>();
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var scooters = await Stream.fromIterable(jsonData)
            .map((value) => Scooter.fromJson(value))
            .toList();

    return scooters;
  }
}

class ScooterBloc extends Bloc<ScooterEvent, List<Scooter>> {
  ScooterBloc() {
    scootersTimer = Timer.periodic(Duration(seconds: 10), getScooters);
  }

  @override
  List<Scooter> get initialState => List<Scooter>();

  Timer scootersTimer;

  @override
  Stream<List<Scooter>> mapEventToState(ScooterEvent event) {
    return event.onEvent().asStream();
  }

  void getScooters(timer) {
    dispatch(ListScooterEvent());
  }

  @override
  void dispose() {
    super.dispose();
    scootersTimer.cancel();
  }
}

class RideData {
  Scooter scooter;
  User user;

  bool valid() {
    return scooter != null;
  }

  bool successful() {
    return scooter != null && user != null;
  }
}

class ValidateRideBloc extends Bloc<String, RideData> {
  @override
  RideData get initialState => RideData();

  @override
  Stream<RideData> mapEventToState(String qr) {
    return getRideData(qr).asStream();
  }

  Future<RideData> getRideData(String qr) async {
    var rideData = RideData();

    rideData.scooter = await getScooter(qr);

    return rideData;
  }

  Future<Scooter> getScooter(String qr) async {
    var response = await http.get(
      Uri.encodeFull(Client.client + 'api/scooters/' + qr),
    );

    if (response.statusCode != 200) {
      return null;
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var scooter = Scooter.fromJson(jsonData);

    if (scooter.isRented) {
      return null;
    }

    return scooter;
  }
}

class BeginRideBloc extends Bloc<RideData, RideData> {
  @override
  RideData get initialState => RideData();

  @override
  Stream<RideData> mapEventToState(RideData rideData) {
    return getRideData(rideData).asStream();
  }

  Future<RideData> getRideData(RideData rideData) async {
    rideData.user = await getUser();

    return rideData;
  }

  Future<User> getUser() async {
    var response = await http.get(
      Uri.encodeFull(Client.client + 'api/users/self'),
      headers: {
        'Authorization': Token.getHeaderToken()
      },
    );

    if (response.statusCode != 200) {
      return null;
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var user = User.fromJson(jsonData);

    return user;
  }
}

class MapBloc {
  ScooterBloc scooterBloc;
  LocationPermissionBloc locationPermissionBloc;
  ValidateRideBloc validateRideBloc;
  BeginRideBloc beginRideBloc;

  MapBloc() {
    scooterBloc = ScooterBloc();
    locationPermissionBloc = LocationPermissionBloc();
    validateRideBloc = ValidateRideBloc();
    beginRideBloc = BeginRideBloc();
  }

  Set<Marker> toMarkers(List<Scooter> scooters) {
    return scooters.map((scooter) => Marker(
      markerId: MarkerId(scooter.pk.toString()),
      position: LatLng(scooter.latitude, scooter.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(scooter.battery.toDouble()),
      infoWindow: InfoWindow(
        title: 'Scooter: ${scooter.pk}',
        snippet: 'Battery: ${scooter.battery} %', 
      ),
    )).toSet();
  }

  void dispose() {
    scooterBloc.dispose();
    locationPermissionBloc.dispose();
    validateRideBloc.dispose();
    beginRideBloc.dispose();
  }
}