import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/repositories/core/map_repository.dart';
import 'package:rive_flutter/providers/core/map_provider_exceptions.dart';
import 'package:rive_flutter/blocs/core/map_bloc_events.dart';
import 'package:rive_flutter/blocs/core/map_bloc_states.dart';
import 'package:rive_flutter/locator.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapRepository mapRepository = getIt<MapRepository>();

  WebSocketChannel scootersChannel;
  WebSocketChannel stationsChannel;

  Timer scootersTimer;

  MapElementsSuccessState prevSuccessState;

  MapBloc() {
    scootersChannel =
        IOWebSocketChannel.connect('${Client.webSocketsClient}/scooters/');
    stationsChannel =
        IOWebSocketChannel.connect('${Client.webSocketsClient}/stations/');
    scootersTimer = Timer.periodic(Duration(seconds: 5), onMapTick);
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
        ]);
        yield MapElementsSuccessState(
          stations: response[0],
          scooters: response[1],
        );
      }
    } on ScootersInternalServerException catch (exc) {
      yield MapErrorState(
        errorMessage: exc.errorMessage,
      );
    } on ScootersUnexpectedException catch (exc) {
      yield MapErrorState(
        errorMessage: exc.errorMessage,
      );
    } on StationsInternalServerException catch (exc) {
      yield MapErrorState(
          errorMessage: exc.errorMessage
      );
    } on StationsUnexpectedException catch (exc) {
      yield MapErrorState(
          errorMessage: exc.errorMessage
      );
    }
  }

  void onMapTick(Timer timer) {
    add(ListMapElementsEvent());
  }

  @override
  Future<void> close() {
    scootersTimer.cancel();
    return super.close();
  }
}
