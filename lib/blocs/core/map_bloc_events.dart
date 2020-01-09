abstract class MapEvent {}

abstract class ScootersEvent extends MapEvent {}

abstract class StationsEvent extends MapEvent {}

class ListMapElementsEvent extends MapEvent {}
class ScootersListEvent extends ScootersEvent {}

class StationsListEvent extends StationsEvent {}