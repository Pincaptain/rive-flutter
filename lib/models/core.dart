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
class ReviewModel extends Object {
  final int rating;
  @JsonKey(name: 'description')
  final String comment;

  ReviewModel(this.rating, this.comment);

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

@JsonSerializable()
class ReviewErrorModel extends Object {
  @JsonKey(name: 'error_message')
  final String errorMessage;

  ReviewErrorModel(this.errorMessage);

  factory ReviewErrorModel.fromJson(Map<String, dynamic> json) => _$ReviewErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewErrorModelToJson(this);
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

@JsonSerializable()
class HistoryPaginated extends Object {
  final int count;
  @JsonKey(name: 'next')
  final String nextPage;
  @JsonKey(name: 'previous')
  final String previousPage;
  @JsonKey(name: 'results')
  final List<Ride> history;

  HistoryPaginated(this.count, this.nextPage, this.previousPage, this.history);

  factory HistoryPaginated.fromJson(Map<String, dynamic> json) => _$HistoryPaginatedFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryPaginatedToJson(this);
}

@JsonSerializable()
class RideErrorModel extends Object {
  @JsonKey(name: 'error_message')
  final String errorMessage;

  RideErrorModel(this.errorMessage);

  factory RideErrorModel.fromJson(Map<String, dynamic> json) =>
      _$RideErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$RideErrorModelToJson(this);
}

@JsonSerializable()
class RideStatus extends Object {
  final bool status;

  RideStatus(this.status);

  factory RideStatus.fromJson(Map<String, dynamic> json) => _$RideStatusFromJson(json);

  Map<String, dynamic> toJson() => _$RideStatusToJson(this);
}

@JsonSerializable()
class ShareCode extends Object{
  final String code;

  ShareCode(this.code);

  factory ShareCode.fromJson(Map<String, dynamic> json) => _$ShareCodeFromJson(json);

  Map<String, dynamic> toJson() => _$ShareCodeToJson(this);

}