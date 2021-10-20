import 'package:json_annotation/json_annotation.dart';

part 'linkedin_user.g.dart';

@JsonSerializable()
class LinkedInUser {
  String id;
  dynamic firstName;
  dynamic lastName;
  dynamic profilePicture;

  LinkedInUser(
      {required this.id,
      this.firstName,
      this.lastName,
      this.profilePicture});

  factory LinkedInUser.fromJson(Map<String, dynamic> json) => _$LinkedInUserFromJson(json);
  Map<String, dynamic> toJson() => _$LinkedInUserToJson(this);
}