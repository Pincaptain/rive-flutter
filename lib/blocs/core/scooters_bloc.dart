//import 'dart:async';
//
//import 'package:bloc/bloc.dart';
//import 'package:web_socket_channel/io.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';
//
//import 'package:rive_flutter/locator.dart';
//import 'package:rive_flutter/providers/core/scooters_provider_exceptions.dart';
//import 'package:rive_flutter/models/auth.dart';
//import 'package:rive_flutter/blocs/core/scooters_bloc_events.dart';
//import 'package:rive_flutter/blocs/core/scooters_bloc_states.dart';
//import 'package:rive_flutter/repositories/core/scooters_repository.dart';
//
//class ScootersBloc extends Bloc<ScootersEvent, ScootersState> {
//  ScootersRepository scootersRepository = getIt<ScootersRepository>();
//
//  WebSocketChannel scootersChannel;
//  StreamSubscription scootersChannelSubscription;
//  Timer scootersTimer;
//
//  ScootersSuccessState prevSuccessState;
//
//  ScootersBloc() {
//    scootersChannel = IOWebSocketChannel.connect('${Client.webSocketsClient}/scooters/');
//    scootersChannelSubscription = scootersChannel.stream.listen(onScootersMessage);
//    scootersTimer = Timer.periodic(Duration(seconds: 5), onScootersTick);
//  }
//
//  @override
//  ScootersState get initialState => ScootersUninitializedState();
//
//  @override
//  Stream<ScootersState> mapEventToState(ScootersEvent event) async* {
//    yield ScootersFetchingState();
//
//    try {
//      var scooters = await scootersRepository.fetchScooters();
//
//      yield ScootersSuccessState(
//        scooters: scooters,
//      );
//    } on ScootersInternalServerException catch (exc) {
//      yield ScootersErrorState(
//        errorMessage: exc.errorMessage,
//      );
//    } on ScootersUnexpectedException catch (exc) {
//      yield ScootersErrorState(
//        errorMessage: exc.errorMessage,
//      );
//    }
//  }
//
//  void onScootersMessage(dynamic message) {
//    add(ScootersListEvent());
//  }
//
//  void onScootersTick(Timer timer) {
//    add(ScootersListEvent());
//  }
//
//  @override
//  Future<void> close() {
//    scootersChannelSubscription.cancel();
//    scootersTimer.cancel();
//    return super.close();
//  }
//}