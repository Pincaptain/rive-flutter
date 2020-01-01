import 'package:get_it/get_it.dart';

import 'package:rive_flutter/repositories/auth/auth_repository.dart';
import 'package:rive_flutter/repositories/core/scooters_repository.dart';
import 'package:rive_flutter/repositories/core/ride_repository.dart';
import 'package:rive_flutter/repositories/extensions/location_repository.dart';
import 'package:rive_flutter/repositories/core/share_code_repository.dart';

GetIt getIt = GetIt.instance;

setupGetIt() {
  getIt.registerFactory(() => AuthenticationRepository());
  getIt.registerFactory(() => ScootersRepository());
  getIt.registerFactory(() => RideRepository());
  getIt.registerFactory(() => LocationRepository());
  getIt.registerFactory(() => ShareCodeRepository());
}