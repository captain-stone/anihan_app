// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_registrations_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerRegistrationsDto _$SellerRegistrationsDtoFromJson(
        Map<String, dynamic> json) =>
    SellerRegistrationsDto(
      storeName: json['storeName'] as String,
      storeAddress: json['storeAddress'] as String,
      isApprove: json['isApprove'] as String?,
    );

Map<String, dynamic> _$SellerRegistrationsDtoToJson(
        SellerRegistrationsDto instance) =>
    <String, dynamic>{
      'storeName': instance.storeName,
      'storeAddress': instance.storeAddress,
      'isApprove': instance.isApprove,
    };
