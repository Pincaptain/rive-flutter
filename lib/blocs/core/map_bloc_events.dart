import 'package:rive_flutter/models/core.dart';

abstract class MapEvent {}

class ListMapElementsEvent extends MapEvent {}

abstract class ScootersEvent extends MapEvent {}

class ListScootersEvent extends ScootersEvent {
  final List<Scooter> scooters;

  ListScootersEvent(this.scooters);
}

abstract class StationsEvent extends MapEvent {}

class ListStationsEvent extends StationsEvent {
  final List<Station> stations;

  ListStationsEvent(this.stations);
}

//TODO with web sockets
class ScootersChangedEvent extends ScootersEvent {}

class StationsChangedEvent extends StationsEvent {}