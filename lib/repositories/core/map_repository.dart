import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/providers/core/map_provider.dart';

class MapRepository {
  ScootersApiProvider scootersApiProvider = ScootersApiProvider();
  StationsApiProvider stationsApiProvider = StationsApiProvider();

  Future<List<Scooter>> fetchScooters() => scootersApiProvider.fetchScooters();
  Future<List<Station>> fetchStations() => stationsApiProvider.fetchStations();

}