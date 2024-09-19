// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInformationDto _$UserInformationDtoFromJson(Map<String, dynamic> json) =>
    UserInformationDto(
      json['displayName'] as String,
      json['remarks'] as String,
      json['emailAddress'] as String,
      (json['phoneNumber'] as num).toInt(),
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$UserInformationDtoToJson(UserInformationDto instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'remarks': instance.remarks,
      'emailAddress': instance.emailAddress,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
    };
