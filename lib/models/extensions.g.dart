// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extensions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) {
  return LocationModel(
    (json['lat'] as num)?.toDouble(),
    (json['lon'] as num)?.toDouble(),
    (json['alt'] as num)?.toDouble(),
    (json['time'] as num)?.toDouble(),
    (json['speed'] as num)?.toDouble(),
    (json['heading'] as num)?.toDouble(),
    (json['accuracy'] as num)?.toDouble(),
    (json['speed_accuracy'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'alt': instance.alt,
      'time': instance.time,
      'speed': instance.speed,
      'heading': instance.heading,
      'accuracy': instance.accuracy,
      'speed_accuracy': instance.speedAccuracy,
    };
