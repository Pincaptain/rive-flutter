import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/models/auth.dart';

enum ScooterEvent {
  list
}

class ScootersBloc extends Bloc<ScooterEvent, List<Scooter>> {
  WebSocketChannel scootersChannel;
  StreamSubscription scootersChannelSubscription;

  ScootersBloc() {
    scootersChannel = IOWebSocketChannel.connect('${Client.webSocketsClient}/scooters/');
    scootersChannelSubscription = scootersChannel.stream.listen(onScootersMessage);

    dispatch(ScooterEvent.list);
  }

  @override
  List<Scooter> get initialState => List<Scooter>();

  @override
  Stream<List<Scooter>> mapEventToState(ScooterEvent scooterEvent) {
    switch (scooterEvent) {
      case ScooterEvent.list:
        return getScooters().asStream();
        
      default:
        return getScooters().asStream();
    }
  }

  Future<List<Scooter>> getScooters() async {
    var response = await http.get(
      Uri.encodeFull('${Client.client}/api/scooters/'),
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
  
  void onScootersMessage(dynamic message) {
    dispatch(ScooterEvent.list);
  }

  @override
  void dispose() {
    super.dispose();
    scootersChannelSubscription.cancel();
  }
}