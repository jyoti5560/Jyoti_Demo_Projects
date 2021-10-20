// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linkedin_access_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkedInAccessToken _$LinkedInAccessTokenFromJson(Map<String, dynamic> json) {
  return LinkedInAccessToken(
    access_token: json['access_token'] as String,
    expires_in: json['expires_in'] as int,
    error: json['error'] as String,
    error_description: json['error_description'] as String,
  );
}

Map<String, dynamic> _$LinkedInAccessTokenToJson(
        LinkedInAccessToken instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'expires_in': instance.expires_in,
      'error': instance.error,
      'error_description': instance.error_description,
    };
