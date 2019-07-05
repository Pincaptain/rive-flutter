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
      json['battery'] as int);
}

Map<String, dynamic> _$ScooterToJson(Scooter instance) => <String, dynamic>{
      'id': instance.pk,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'is_rented': instance.isRented,
      'battery': instance.battery
    };
