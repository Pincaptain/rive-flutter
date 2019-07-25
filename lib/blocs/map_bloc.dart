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
  @override
  List<Scooter> get initialState => List<Scooter>();

  @override
  Stream<List<Scooter>> mapEventToState(ScooterEvent event) {
    return event.onEvent().asStream();
  }
}

class RideData {
  Scooter scooter;

  bool isSuccessful() {
    return scooter != null;
  }
}

class BeginRideBloc extends Bloc<String, RideData> {
  @override
  RideData get initialState => RideData();

  @override
  Stream<RideData> mapEventToState(String event) {
    return getRideData(event).asStream();
  }

  Future<RideData> getRideData(String id) async {
    var rideData = RideData();

    rideData.scooter = await getScooter(id);

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
}

class MapBloc {
  ScooterBloc scooterBloc;
  LocationPermissionBloc locationPermissionBloc;
  BeginRideBloc beginRideBloc;

  Timer scooterGetTimer;

  MapBloc() {
    scooterBloc = ScooterBloc();
    locationPermissionBloc = LocationPermissionBloc();
    beginRideBloc = BeginRideBloc();
    scooterGetTimer = Timer.periodic(Duration(seconds: 10), getScooters);
  }

  void getScooters(timer) {
    scooterBloc.dispatch(ListScooterEvent());
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
    beginRideBloc.dispose();
    scooterGetTimer.cancel();
  }
}