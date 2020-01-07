import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/providers/core/ride_provider.dart';

class RideRepository {
  RideApiProvider rideApiProvider = RideApiProvider();

  Future<RideStatus> fetchRideStatus() => rideApiProvider.fetchRideStatus();

  Future<Ride> beginRide(String qrCode) => rideApiProvider.beginRide(qrCode);

  Future<Ride> fetchRide() => rideApiProvider.fetchRide();

  Future<void> endRide() => rideApiProvider.endRide();

  Future<List<Ride>> fetchHistory() => rideApiProvider.fetchHistory();

  Future<List<Ride>> fetchHistoryPaginated(int page) => rideApiProvider.fetchHistoryPaginated(page);

  Future<void> sendReview(ReviewModel reviewModel) => rideApiProvider.sendReview(reviewModel);
}