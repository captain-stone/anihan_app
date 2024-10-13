// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
      productName: json['productName'] as String,
      productprice: (json['productprice'] as num).toInt(),
      productImamgeData: json['productImamgeData'] as String,
    );

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'productprice': instance.productprice,
      'productImamgeData': instance.productImamgeData,
    };

ProductVariantDto _$ProductVariantDtoFromJson(Map<String, dynamic> json) =>
    ProductVariantDto(
      productVariantId: (json['productVariantId'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, ProductDto.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ProductVariantDtoToJson(ProductVariantDto instance) =>
    <String, dynamic>{
      'productVariantId': instance.productVariantId,
    };
