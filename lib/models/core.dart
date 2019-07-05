import 'package:json_annotation/json_annotation.dart';

part 'core.g.dart';

@JsonSerializable()
class Scooter extends Object {
  @JsonKey(name: 'id')
  final int pk;
  final double longitude;
  final double latitude;
  @JsonKey(name: 'is_rented')
  final bool isRented;
  final int battery;

  Scooter(this.pk, this.longitude, this.latitude, this.isRented, this.battery);

  factory Scooter.fromJson(Map<String, dynamic> json) => _$ScooterFromJson(json);

  Map<String, dynamic> toJson() => _$ScooterToJson(this);
}