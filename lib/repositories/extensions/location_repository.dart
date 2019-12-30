import 'package:location/location.dart';

import 'package:rive_flutter/providers/extensions/location_provider.dart';

class LocationRepository {
  LocationApiProvider locationApiProvider = LocationApiProvider();

  Future<void> sendLocation(LocationData locationData) =>
      locationApiProvider.sendLocation(locationData);
}