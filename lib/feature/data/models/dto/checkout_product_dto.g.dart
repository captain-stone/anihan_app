// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutProductDto _$CheckoutProductDtoFromJson(Map<String, dynamic> json) =>
    CheckoutProductDto(
      id: json['id'] as String?,
      buyer: json['buyer'] as String,
      buyerName: json['buyerName'] as String,
      deliveryDate: json['deliveryDate'] as String,
      messageToSeller: json['messageToSeller'] as String,
      storeId: json['storeId'] as String,
      timeStamp: json['timeStamp'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      productList: (json['productList'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      forApproval: json['forApproval'] as String,
    );

Map<String, dynamic> _$CheckoutProductDtoToJson(CheckoutProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'buyer': instance.buyer,
      'buyerName': instance.buyerName,
      'deliveryDate': instance.deliveryDate,
      'messageToSeller': instance.messageToSeller,
      'storeId': instance.storeId,
      'timeStamp': instance.timeStamp,
      'totalPrice': instance.totalPrice,
      'forApproval': instance.forApproval,
      'productList': instance.productList,
    };
