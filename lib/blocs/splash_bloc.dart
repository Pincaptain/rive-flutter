import 'dart:async';

import 'package:bloc/bloc.dart';

class LocationPermissionBloc extends Bloc<bool, bool> {

  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(bool event) async* {
    yield event;
  }

}

class SplashBloc {

  LocationPermissionBloc locationPermissionBloc;

  SplashBloc() {
    locationPermissionBloc = LocationPermissionBloc();
  }

  dispose() {
    locationPermissionBloc.dispose();
  }

}
