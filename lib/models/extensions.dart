import 'package:json_annotation/json_annotation.dart';

part 'extensions.g.dart';

/* 
Map<String, dynamic> locationDataJson = {
      'lat': locationData.latitude,
      'lon': locationData.longitude,
      'alt': locationData.altitude,
      'time': locationData.time,
      'speed': locationData.speed,
      'heading': locationData.heading,
      'accuracy': locationData.accuracy,
      'speed_accuracy': locationData.speedAccuracy
    };
*/

@JsonSerializable()
class LocationInfo {
  final double lat;
  final double lon;
  final double alt;
  final double time;
  final double speed;
  final double heading;
  final double accuracy;
  @JsonKey(name: 'speed_accuracy')
  final double speedAccuracy;

  LocationInfo(this.lat, this.lon, this.alt, this.time, this.speed, this.heading, this.accuracy, this.speedAccuracy);

  factory LocationInfo.fromJson(Map<String, dynamic> json) => _$LocationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationInfoToJson(this);
}
