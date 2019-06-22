import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';

enum ConnectivityEvent { check }

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityResult> {

  @override
  ConnectivityResult get initialState => ConnectivityResult.none;

  @override
  Stream<ConnectivityResult> mapEventToState(ConnectivityEvent event) {
    return Connectivity().onConnectivityChanged;
  }

}

enum LocationPermissionEvent { agree, disagree }

class LocationPermissionBloc extends Bloc<LocationPermissionEvent, bool> {

  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(LocationPermissionEvent event) async* {
    switch(event) {
      case LocationPermissionEvent.agree:
        yield true;
        break;
      
      case LocationPermissionEvent.disagree:
        yield false;
        break;

      default:
        throw Exception('Unhandled event $event');
    }
  }

}

class SplashBloc {

  ConnectivityBloc connectivityBloc;
  LocationPermissionBloc locationPermissionBloc;

  SplashBloc() {
    connectivityBloc = ConnectivityBloc();
    locationPermissionBloc = LocationPermissionBloc();
  }

  dispose() {
    connectivityBloc.dispose();
    locationPermissionBloc.dispose();
  }

}
