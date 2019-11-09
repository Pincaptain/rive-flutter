import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

class Client {
  static String client = 'https://314e2725.ngrok.io';
  static String webSocketsClient = 'ws://314e2725.ngrok.io';
}

class Token {
  static String token;

  static bool isAuthenticated() {
    return token != null;
  }

  static void authenticate(String token) {
    Token.token = token;
  }

  static void forget() {
    token = null;
  }

  static String getHeaderToken() {
    if (token == null) {
      return null;
    }

    return 'Token $token';
  }
}

@JsonSerializable()
class User extends Object {
  @JsonKey(name: 'id')
  final int pk;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  User(this.pk, this.firstName, this.lastName, this.email, this.phoneNumber);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}