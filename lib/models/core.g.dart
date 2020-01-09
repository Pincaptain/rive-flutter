// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scooter _$ScooterFromJson(Map<String, dynamic> json) {
  return Scooter(
    json['id'] as int,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['is_rented'] as bool,
    json['battery'] as int,
  );
}

Map<String, dynamic> _$ScooterToJson(Scooter instance) => <String, dynamic>{
      'id': instance.pk,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'is_rented': instance.isRented,
      'battery': instance.battery,
    };

Station _$StationFromJson(Map<String, dynamic> json) {
  return Station(
    json['id'] as int,
    json['name'] as String,
    json['scooter_count'] as int,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
    json['capacity'] as int,
    json['date_added'] == null
        ? null
        : DateTime.parse(json['date_added'] as String),
    json['station_model'] as String,
    json['station_confirmation_status'] as String,
  );
}

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'id': instance.pk,
      'name': instance.name,
      'scooter_count': instance.scooterCount,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'capacity': instance.capacity,
      'date_added': instance.dateAdded?.toIso8601String(),
      'station_model': instance.stationModel,
      'station_confirmation_status': instance.confirmationStatus,
    };

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review(
    json['id'] as int,
    json['rating'] as int,
    json['description'] as String,
  );
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.pk,
      'rating': instance.rating,
      'description': instance.comment,
    };

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) {
  return ReviewModel(
    json['rating'] as int,
    json['description'] as String,
  );
}

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'description': instance.comment,
    };

ReviewErrorModel _$ReviewErrorModelFromJson(Map<String, dynamic> json) {
  return ReviewErrorModel(
    json['error_message'] as String,
  );
}

Map<String, dynamic> _$ReviewErrorModelToJson(ReviewErrorModel instance) =>
    <String, dynamic>{
      'error_message': instance.errorMessage,
    };

Ride _$RideFromJson(Map<String, dynamic> json) {
  return Ride(
    json['id'] as int,
    json['is_finished'] as bool,
    (json['price'] as num)?.toDouble(),
    json['started'] == null ? null : DateTime.parse(json['started'] as String),
    json['finished'] == null
        ? null
        : DateTime.parse(json['finished'] as String),
    json['review'] == null
        ? null
        : Review.fromJson(json['review'] as Map<String, dynamic>),
    json['scooter'] == null
        ? null
        : Scooter.fromJson(json['scooter'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'id': instance.pk,
      'is_finished': instance.isFinished,
      'price': instance.price,
      'started': instance.startedDate?.toIso8601String(),
      'finished': instance.finishedDate?.toIso8601String(),
      'review': instance.review,
      'scooter': instance.scooter,
      'user': instance.user,
    };

RideErrorModel _$RideErrorModelFromJson(Map<String, dynamic> json) {
  return RideErrorModel(
    json['error_message'] as String,
  );
}

Map<String, dynamic> _$RideErrorModelToJson(RideErrorModel instance) =>
    <String, dynamic>{
      'error_message': instance.errorMessage,
    };

HistoryPaginated _$HistoryPaginatedFromJson(Map<String, dynamic> json) {
  return HistoryPaginated(
    json['count'] as int,
    json['next'] as String,
    json['previous'] as String,
    (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Ride.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HistoryPaginatedToJson(HistoryPaginated instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.nextPage,
      'previous': instance.previousPage,
      'results': instance.history,
    };

RideStatus _$RideStatusFromJson(Map<String, dynamic> json) {
  return RideStatus(
    json['status'] as bool,
  );
}

Map<String, dynamic> _$RideStatusToJson(RideStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
    };

ShareCode _$ShareCodeFromJson(Map<String, dynamic> json) {
  return ShareCode(
    json['code'] as String,
  );
}

Map<String, dynamic> _$ShareCodeToJson(ShareCode instance) => <String, dynamic>{
      'code': instance.code,
    };

ShareCodeErrorModel _$ShareCodeErrorModelFromJson(Map<String, dynamic> json) {
  return ShareCodeErrorModel(
    json['error_message'] as String,
  );
}

Map<String, dynamic> _$ShareCodeErrorModelToJson(
        ShareCodeErrorModel instance) =>
    <String, dynamic>{
      'error_message': instance.errorMessage,
    };
