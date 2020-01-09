import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/repositories/core/map_repository.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:rive_flutter/providers/core/map_provider_exceptions.dart';

import 'map_bloc_events.dart';
import 'map_bloc_states.dart';
import 'package:rive_flutter/locator.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapRepository mapRepository = getIt<MapRepository>();

  WebSocketChannel scootersChannel;
  StreamSubscription scootersChannelSubscription;
  Timer scootersTimer;

  ScootersSuccessState prevScootersSuccessState;
  StationsSuccessState prevStationsSuccessState;

  MapBloc() {
    scootersChannel =
        IOWebSocketChannel.connect('${Client.webSocketsClient}/scooters/');
    scootersChannelSubscription =
        scootersChannel.stream.listen(onScootersMessage);
    scootersTimer = Timer.periodic(Duration(seconds: 5), onScootersTick);
  }

  @override
  MapState get initialState => MapUninitializedState();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {

    try {
      if (event is ListMapElementsEvent) {
        // makes 2 async calls, instead of 2 seperate await calls we just wait for the requests to finish
        var response = await Future.wait([
          mapRepository.fetchStations(),
          mapRepository.fetchScooters(),
        ]);
        yield MapElementsSuccessState(
          stations: response[0],
          scooters: response[1],
        );
      }else if(event is ScootersListEvent) {
        //TODO -> on scooters tick
        //
      }

    } on ScootersInternalServerException catch (exc) {
      yield ScootersErrorState(
        errorMessage: exc.errorMessage,
      );
    } on ScootersUnexpectedException catch (exc) {
      yield ScootersErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }

  void onScootersMessage(dynamic message) {
    add(ScootersListEvent());
  }

  void onScootersTick(Timer timer) {
    add(ScootersListEvent());
  }

  @override
  Future<void> close() {
    scootersChannelSubscription.cancel();
    scootersTimer.cancel();

    return super.close();
  }
}
