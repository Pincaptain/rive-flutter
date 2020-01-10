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
  WebSocketChannel stationsChannel;

  StreamSubscription scootersChannelSubscription;
  StreamSubscription stationsChannelSubscription;

  Timer scootersTimer;

  MapElementsSuccessState prevSuccessState;

  MapBloc() {
    scootersChannel =
        IOWebSocketChannel.connect('${Client.webSocketsClient}/scooters/');
    stationsChannel =
        IOWebSocketChannel.connect('${Client.webSocketsClient}/stations/');
    scootersChannelSubscription =
        scootersChannel.stream.listen(onScootersMessage);
    stationsChannelSubscription =
        stationsChannel.stream.listen(onStationsMessage);
    scootersTimer = Timer.periodic(Duration(seconds: 5), onScootersTick);
  }

  @override
  MapState get initialState => MapUninitializedState();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    try {
      if (event is ListMapElementsEvent) {
        var response = await Future.wait([
          mapRepository.fetchStations(),
          mapRepository.fetchScooters(),
        ], cleanUp: (value) {
          if (value is List<Station>) {
            log("LIST STATIONS");
            onStationsMessage(value);
          } else if (value is List<Scooter>) {
            log("LIST SCOOTERS");
            onScootersMessage(value);
          }
        });
        yield MapElementsSuccessState(
          stations: response[0],
          scooters: response[1],
        );
      } else if (event is ListStationsEvent) {
        yield StationsSuccessState(
            stations: event.stations
        );
      } else if (event is ListScootersEvent) {
        yield ScootersSuccessState(
            scooters: event.scooters
        );
      }
    } on ScootersInternalServerException catch (exc) {
      yield ScootersErrorState(
        errorMessage: exc.errorMessage,
      );
    } on ScootersUnexpectedException catch (exc) {
      yield ScootersErrorState(
        errorMessage: exc.errorMessage,
      );
    } on StationsInternalServerException catch (exc) {
      yield StationsErrorState(
          errorMessage: exc.errorMessage
      );
    } on StationsUnexpectedException catch (exc) {
      yield StationsErrorState(
          errorMessage: exc.errorMessage
      );
    }
  }

  void onScootersMessage(dynamic message) {
    add(ListScootersEvent(message));
  }

  void onScootersTick(Timer timer) {
//    add(ListStationsEvent());
  }

  void onStationsMessage(dynamic message) {
    add(ListStationsEvent(message));
  }

  @override
  Future<void> close() {
    scootersChannelSubscription.cancel();
    stationsChannelSubscription.cancel();
    scootersTimer.cancel();
    return super.close();
  }
}
