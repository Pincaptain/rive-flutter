import 'package:json_annotation/json_annotation.dart';

part 'extensions.g.dart';

@JsonSerializable()
class LocationModel {
  final double lat;
  final double lon;
  final double alt;
  final double time;
  final double speed;
  final double heading;
  final double accuracy;
  @JsonKey(name: 'speed_accuracy')
  final double speedAccuracy;

  LocationModel(this.lat, this.lon, this.alt, this.time, this.speed,
      this.heading, this.accuracy, this.speedAccuracy);

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
