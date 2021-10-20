// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linkedin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkedInUser _$LinkedInUserFromJson(Map<String, dynamic> json) {
  return LinkedInUser(
    id: json['id'] as String,
    firstName: json['firstName'],
    lastName: json['lastName'],
    profilePicture: json['profilePicture'],
  );
}

Map<String, dynamic> _$LinkedInUserToJson(LinkedInUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePicture': instance.profilePicture,
    };
