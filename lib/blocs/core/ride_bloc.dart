import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/models/auth.dart';

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
    return ride == null && errorMessage.isEmpty && errorType == null;
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

  RideBloc() {
    rideChannel = IOWebSocketChannel.connect('${Client.webSocketsClient}/ride/');
    rideChannel.sink.add(Token.token);
    rideChannelSubscription = rideChannel.stream.listen(onRideMessage);
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

  @override
  void dispose() {
    super.dispose();
    rideChannelSubscription.cancel();
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