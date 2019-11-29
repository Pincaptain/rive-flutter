// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) {
  return TokenModel(json['key'] as String);
}

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{'key': instance.token};

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['id'] as int,
      json['first_name'] as String,
      json['last_name'] as String,
      json['email'] as String,
      json['phone_number'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.pk,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone_number': instance.phoneNumber
    };

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) {
  return LoginModel(json['username'] as String, json['password'] as String);
}

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password
    };

RegisterModel _$RegisterModelFromJson(Map<String, dynamic> json) {
  return RegisterModel(json['username'] as String, json['email'] as String,
      json['password1'] as String, json['password2'] as String);
}

Map<String, dynamic> _$RegisterModelToJson(RegisterModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password1': instance.password1,
      'password2': instance.password2
    };

RegisterErrorModel _$RegisterErrorModelFromJson(Map<String, dynamic> json) {
  return RegisterErrorModel(
      (json['username'] as List)?.map((e) => e as String)?.toList(),
      (json['email'] as List)?.map((e) => e as String)?.toList(),
      (json['password1'] as List)?.map((e) => e as String)?.toList(),
      (json['password2'] as List)?.map((e) => e as String)?.toList(),
      (json['non_field_errors'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$RegisterErrorModelToJson(RegisterErrorModel instance) =>
    <String, dynamic>{
      'username': instance.usernameErrors,
      'email': instance.emailErrors,
      'password1': instance.password1Errors,
      'password2': instance.password2Errors,
      'non_field_errors': instance.nonFieldErrors
    };
