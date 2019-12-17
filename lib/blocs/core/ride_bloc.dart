import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/models/extensions.dart';

enum RideErrorType {
  authentication,
  client,
  server
}

class RideData {
  Ride ride;
  String errorMessage;
  RideErrorType errorType;

  bool isValid() {
    return errorMessage == null && errorType == null;
  }

  bool isInitial() {
    return ride == null && errorMessage == null && errorType == null;
  }
}

class BeginRideBloc extends Bloc<String, RideData> {
  @override
  RideData get initialState => RideData();

  @override
  Stream<RideData> mapEventToState(String qrCode) {
    return getRideData(qrCode).asStream();
  }

  Future<RideData> getRideData(String qrCode) async {
    RideData rideData = RideData();

    if (!Token.isAuthenticated()) {
      rideData.errorMessage = 'Only authenticated users can begin a ride!';
      rideData.errorType = RideErrorType.authentication;

      return rideData;
    }

    var response = await http.get(
      Uri.encodeFull('${Client.client}/api/rides/$qrCode/rent/'),
      headers: {
        'Authorization': Token.getHeaderToken(),
      },
    );
    var statusCodeClass = (response.statusCode / 100).floor();

    switch (statusCodeClass) {
      case 4:
        rideData.errorMessage = 'Invalid scooter code or scooter already rented! If this problem persists contact support!';
        rideData.errorType = RideErrorType.client;

        return rideData;

      case 5:
        rideData.errorMessage = 'An error occurred on the server. This may be due to maintenance. Please try again soon!';
        rideData.errorType = RideErrorType.server;

        return rideData;
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var ride = Ride.fromJson(jsonData);

    rideData.ride = ride;

    print(rideData.ride.scooter.pk);

    return rideData;
  }
}

enum RideEvent {
  check,
  end
}

class RideBloc extends Bloc<RideEvent, RideData> {
  WebSocketChannel rideChannel;
  StreamSubscription rideChannelSubscription;
  StreamSubscription locationSubscription;
  Timer rideTimer;

  RideBloc() {
    rideChannel = IOWebSocketChannel.connect('${Client.webSocketsClient}/ride/');
    rideChannel.sink.add(Token.token);
    rideChannelSubscription = rideChannel.stream.listen(onRideMessage);
    locationSubscription = Location().onLocationChanged().listen(onLocationData);
    rideTimer = Timer.periodic(Duration(seconds: 10), onRideTick);

    dispatch(RideEvent.check);
  }

  @override
  RideData get initialState => RideData();

  @override
  Stream<RideData> mapEventToState(RideEvent rideEvent) {
    switch (rideEvent) {
      case RideEvent.check:
        return getRideData().asStream();
        
      default:
        return getRideData().asStream();
    }
  }

  Future<RideData> getRideData() async {
    RideData rideData = RideData();

    if (!Token.isAuthenticated()) {
      rideData.errorMessage = 'Ops! Your authentication credentials were lost in transition.';
      rideData.errorType = RideErrorType.authentication;

      return rideData;
    }

    var response = await http.get(
      Uri.encodeFull('${Client.client}/api/rides/current/'),
      headers: {
        'Authorization': Token.getHeaderToken(),
      },
    );
    var statusCodeClass = (response.statusCode / 100).floor();

    switch (statusCodeClass) {
      case 4:
        rideData.errorMessage = 'This is a weird problem. Probably a result of time travel or a genious mind! If this problem persists contact support!';
        rideData.errorType = RideErrorType.client;

        return rideData;

      case 5:
        rideData.errorMessage = 'An error occurred on the server. This may be due to maintenance. Patience is a virtue!';
        rideData.errorType = RideErrorType.server;

        return rideData;
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var ride = Ride.fromJson(jsonData);

    rideData.ride = ride;

    return rideData;
  }

  void onRideMessage(dynamic message) {
    dispatch(RideEvent.check);
  }

  void onLocationData(LocationData locationData) async {
    var locationInfo = LocationInfo(
      locationData.latitude,
      locationData.longitude,
      locationData.altitude,
      locationData.time,
      locationData.speed,
      locationData.heading,
      locationData.accuracy,
      locationData.speedAccuracy
    );

    var response = await http.post(
      Uri.encodeFull('${Client.client}/api/rides/send_location/'),
      headers: {
        'Authorization': Token.getHeaderToken(),
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: json.encode(locationInfo.toJson()),
    );

    print(response.statusCode);
  }

  void onRideTick(Timer timer) {
    dispatch(RideEvent.check);
  }

  @override
  void dispose() {
    super.dispose();
    rideChannelSubscription.cancel();
    locationSubscription.cancel();
    rideTimer.cancel();
  }
}

class EndRideBloc extends Bloc<RideEvent, bool> {
  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(RideEvent rideEvent) {
    switch (rideEvent) {
      case RideEvent.end:
        return getEndRideData().asStream();
        
      default:
        return getEndRideData().asStream();
    }
  }

  Future<bool> getEndRideData() async {
    var response = await http.get(
      Uri.encodeFull('${Client.client}/api/rides/end_ride/'),
      headers: {
        'Authorization': Token.getHeaderToken(),
      },
    );
    var statusCodeClass = (response.statusCode / 100).floor();

    if (statusCodeClass != 2) {
      return false;
    }

    return true;
  }
}

enum HistoryEvent {
  list,
}

class HistoryBloc extends Bloc<HistoryEvent, List<Ride>> {
  @override
  List<Ride> get initialState => List<Ride>();

  @override
  Stream<List<Ride>> mapEventToState(HistoryEvent historyEvent) {
    switch (historyEvent) {
      case HistoryEvent.list:
        return getRides().asStream();
        
      default:
        return getRides().asStream();
    }
  }

  Future<List<Ride>> getRides() async {
    var response = await http.get(
      Uri.encodeFull('${Client.client}/api/rides/'),
      headers: {
        'Authorization': Token.getHeaderToken(),
      },
    );

    if (response.statusCode != 200) {
      return List<Ride>();
    }

    var jsonString = utf8.decode(response.bodyBytes);
    var jsonData = json.decode(jsonString);
    var rides = await Stream.fromIterable(jsonData)
            .map((value) => Ride.fromJson(value))
            .toList();

    return rides;
  }
}