import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth.g.dart';

class Client {
  static String client = 'http://134.209.229.173';
  static String webSocketsClient = 'ws://134.209.229.173';
}

class Token {
  static String token;

  static bool isAuthenticated() {
    return token != null;
  }

  static void authenticate(String token) {
    Token.token = token;
    Token.storeToken(token);
  }

  static void storeToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  static void tryAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? null;

    if (token != null) {
      Token.token = token;
    }
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
class TokenModel extends Object {
  @JsonKey(name: 'key')
  final String token;

  TokenModel(this.token);

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
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

@JsonSerializable()
class LoginModel extends Object {
  final String username;
  final String password;

 LoginModel(this.username, this.password);

 factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);

 Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}

@JsonSerializable()
class RegisterModel extends Object {
  final String username;
  final String email;
  final String password1;
  final String password2;

  RegisterModel(this.username, this.email, this.password1, this.password2);

  factory RegisterModel.fromJson(Map<String, dynamic> json) => _$RegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}

@JsonSerializable()
class RegisterErrorModel extends Object {
  @JsonKey(name: 'username')
  final List<String> usernameErrors;
  @JsonKey(name: 'email')
  final List<String> emailErrors;
  @JsonKey(name: 'password1')
  final List<String> password1Errors;
  @JsonKey(name: 'password2')
  final List<String> password2Errors;
  @JsonKey(name: 'non_field_errors')
  final List<String> nonFieldErrors;

  RegisterErrorModel(this.usernameErrors, this.emailErrors, this.password1Errors, this.password2Errors, this.nonFieldErrors);

  factory RegisterErrorModel.fromJson(Map<String, dynamic> json) => _$RegisterErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterErrorModelToJson(this);
}