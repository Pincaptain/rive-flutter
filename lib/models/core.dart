import 'package:json_annotation/json_annotation.dart';

import 'package:rive_flutter/models/auth.dart';

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

@JsonSerializable()
class Review extends Object {
  @JsonKey(name: 'id')
  final int pk;
  final int rating;
  @JsonKey(name: 'description')
  final String comment;

  Review(this.pk, this.rating, this.comment);

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable()
class Ride extends Object {
  @JsonKey(name: 'id')
  final int pk;
  @JsonKey(name: 'is_finished')
  final bool isFinished;
  final double price;
  @JsonKey(name: 'started')
  final DateTime startedDate;
  @JsonKey(name: 'finished')
  final DateTime finishedDate;
  final Review review;
  final Scooter scooter;
  final User user;

  Ride(this.pk, this.isFinished, this.price, this.startedDate, this.finishedDate, this.review, this.scooter, this.user);

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);
}