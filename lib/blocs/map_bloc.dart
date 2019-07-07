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

class MapBloc {
  ScooterBloc scooterBloc;
  LocationPermissionBloc locationPermissionBloc;

  Timer scooterGetTimer;

  MapBloc() {
    scooterBloc = ScooterBloc();
    locationPermissionBloc = LocationPermissionBloc();
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
        snippet: 'Battery: ${scooter.battery}', 
      ),
    )).toSet();
  }

  void dispose() {
    scooterBloc.dispose();
    locationPermissionBloc.dispose();
    scooterGetTimer.cancel();
  }
}