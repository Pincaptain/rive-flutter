import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:rive_flutter/models/auth.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_events.dart';
import 'package:rive_flutter/blocs/core/ride_bloc_states.dart';
import 'package:rive_flutter/locator.dart';
import 'package:rive_flutter/providers/core/ride_provider_exceptions.dart';
import 'package:rive_flutter/repositories/core/ride_repository.dart';
import 'package:rive_flutter/repositories/extensions/location_repository.dart';

class RideStatusBloc extends Bloc<RideStatusEvent, RideStatusState> {
  RideRepository rideRepository = getIt<RideRepository>();

  Timer rideStatusTimer;

  RideStatusBloc() {
    rideStatusTimer = Timer.periodic(Duration(seconds: 10), onRideStatusTick);
  }

  @override
  RideStatusState get initialState => RideStatusUninitializedState();

  @override
  Stream<RideStatusState> mapEventToState(RideStatusEvent event) async* {
    yield RideStatusFetchingState();

    try {
      final rideStatus = await rideRepository.fetchRideStatus();

      if (rideStatus.status) {
        yield RideStatusInRideState();
      } else {
        yield RideStatusIdleState();
      }
    } on RideStatusUnauthorizedException {
      yield RideStatusErrorState();
    } on RideStatusInternalServerException {
      yield RideStatusErrorState();
    } on RideStatusUnexpectedException {
      yield RideStatusErrorState();
    }
  }

  void onRideStatusTick(Timer timer) {
    add(RideStatusCheckEvent());
  }

  @override
  Future<void> close() {
    rideStatusTimer.cancel();
    return super.close();
  }
}

class BeginRideBloc extends Bloc<BeginRideEvent, BeginRideState> {
  RideRepository rideRepository = getIt<RideRepository>();

  @override
  BeginRideState get initialState => BeginRideUninitializedState();

  @override
  Stream<BeginRideState> mapEventToState(BeginRideEvent event) async* {
    yield BeginRideFetchingState();

    try {
      final ride = await rideRepository.beginRide(event.qrCode);

      yield BeginRideSuccessState(
        ride: ride,
      );
    } on BeginRideBadRequestException catch (exc) {
      yield BeginRideErrorState(
          errorMessage: exc.getErrorMessage(),
      );
    } on BeginRideUnauthorizedState catch (exc) {
      yield BeginRideUnauthorizedState(
        errorMessage: exc.errorMessage,
      );
    } on BeginRideInternalServerException catch (exc) {
      yield BeginRideErrorState(
        errorMessage: exc.errorMessage,
      );
    } on BeginRideUnexpectedException catch (exc) {
      yield BeginRideErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }
}

class RideBloc extends Bloc<RideEvent, RideState> {
  RideRepository rideRepository = getIt<RideRepository>();
  LocationRepository locationRepository = getIt<LocationRepository>();

  WebSocketChannel rideChannel;
  StreamSubscription rideChannelSubscription;
  StreamSubscription locationSubscription;
  Timer rideTimer;

  RideBloc() {
    locationSubscription = Location().onLocationChanged().listen(onLocationChanged);

    rideChannel = IOWebSocketChannel.connect('${Client.webSocketsClient}/ride/');
    rideChannel.sink.add(Token.token);
    rideChannelSubscription = rideChannel.stream.listen(onRideMessage);
    rideTimer = Timer.periodic(Duration(seconds: 10), onRideTick);
  }

  @override
  RideState get initialState => RideUninitializedState();

  @override
  Stream<RideState> mapEventToState(RideEvent event) async* {
    yield RideFetchingState();

    try {
      final ride = await rideRepository.fetchRide();

      yield RideSuccessState(
        ride: ride,
      );
    } on RideBadRequestException catch (exc) {
      yield RideErrorState(
        errorMessage: exc.getErrorMessage(),
      );
    } on RideUnauthorizedException catch (exc) {
      yield RideErrorState(
        errorMessage: exc.errorMessage,
      );
    } on RideInternalServerException catch (exc) {
      yield RideErrorState(
        errorMessage: exc.errorMessage,
      );
    } on RideUnexpectedException catch (exc) {
      yield RideErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }

  void onLocationChanged(LocationData locationData) async {
    locationRepository.sendLocation(locationData);
  }

  void onRideMessage(dynamic message) {
    add(RideCheckEvent());
  }

  void onRideTick(Timer timer) {
    add(RideCheckEvent());
  }

  @override
  Future<void> close() {
    rideChannelSubscription.cancel();
    locationSubscription.cancel();
    rideTimer.cancel();
    return super.close();
  }
}

class EndRideBloc extends Bloc<EndRideEvent, EndRideState> {
  RideRepository rideRepository = getIt<RideRepository>();

  @override
  EndRideState get initialState => EndRideUninitializedState();

  @override
  Stream<EndRideState> mapEventToState(EndRideEvent event) async* {
    yield EndRideFetchingState();

    try {
      await rideRepository.endRide();

      yield EndRideSuccessState();
    } on EndRideBadRequestException catch (exc) {
      yield EndRideErrorState(
        errorMessage: exc.errorMessage,
      );
    } on EndRideUnauthorizedState catch (exc) {
      yield EndRideUnauthorizedState(
        errorMessage: exc.errorMessage,
      );
    } on EndRideInternalServerException catch (exc) {
      yield EndRideErrorState(
        errorMessage: exc.errorMessage,
      );
    } on EndRideUnexpectedException catch (exc) {
      yield EndRideErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  RideRepository rideRepository = getIt<RideRepository>();

  @override
  HistoryState get initialState => HistoryUninitializedState();

  HistoryPaginatedSuccessState currentState;

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent event) async* {
    yield HistoryFetchingState();

    try {
      if (event is HistoryListEvent) {
        final history = await rideRepository.fetchHistory();

        yield HistorySuccessState(
          history: history,
        );
      } else if (event is HistoryPaginatedEvent) {
        if (currentState != null) {
          final history = await rideRepository.fetchHistoryPaginated(currentState.page + 1);
          currentState = HistoryPaginatedSuccessState(
            history: currentState.history + history,
            page: currentState.page + 1,
          );

          yield currentState;
        } else {
          final history = await rideRepository.fetchHistoryPaginated(1);
          currentState = HistoryPaginatedSuccessState(
            history: history,
            page: 1,
          );

          yield currentState;
        }
      }
    } on HistoryBadRequestException catch (exc) {
      yield HistoryErrorState(
        errorMessage: exc.errorMessage,
      );
    } on HistoryUnauthorizedException catch (exc) {
      yield HistoryErrorState(
        errorMessage: exc.errorMessage,
      );
    } on HistoryPageNotFoundException {
      yield HistoryPaginatedFinishedState();
    } on HistoryInternalServerException catch (exc) {
      yield HistoryErrorState(
        errorMessage: exc.errorMessage,
      );
    } on HistoryUnexpectedException catch (exc) {
      yield HistoryErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }
}

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  RideRepository rideRepository = getIt<RideRepository>();

  @override
  ReviewState get initialState => ReviewUninitializedState();

  @override
  Stream<ReviewState> mapEventToState(ReviewEvent event) async* {
    try {
      final sendEvent = event as ReviewSendEvent;
      await rideRepository.sendReview(sendEvent.reviewModel);

      yield ReviewSuccessState();
    } on ReviewBadRequestException catch (exc) {
      yield ReviewErrorState(
        errorMessage: exc.getErrorMessage(),
      );
    } on ReviewUnauthorizedException catch (exc) {
      yield ReviewErrorState(
        errorMessage: exc.errorMessage,
      );
    } on ReviewInternalServerException catch (exc) {
      yield ReviewErrorState(
        errorMessage: exc.errorMessage,
      );
    } on ReviewUnexpectedException catch (exc) {
      yield ReviewErrorState(
        errorMessage: exc.errorMessage,
      );
    }
  }
}