// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVariantDto _$ProductVariantDtoFromJson(Map<String, dynamic> json) =>
    ProductVariantDto(
      variantName: json['variantName'] as String?,
      variantPrice: json['variantPrice'] as String?,
      variantImages: json['variantImages'] as String?,
      variantQuantity: json['variantQuantity'] as String?,
    );

Map<String, dynamic> _$ProductVariantDtoToJson(ProductVariantDto instance) =>
    <String, dynamic>{
      'variantName': instance.variantName,
      'variantPrice': instance.variantPrice,
      'variantImages': instance.variantImages,
      'variantQuantity': instance.variantQuantity,
    };

ProductDataDto _$ProductDataDtoFromJson(Map<String, dynamic> json) =>
    ProductDataDto(
      imageList: (json['imageUrls'] as List<dynamic>)
          .map((e) => e as String?)
          .toList(),
      productName: json['name'] as String,
      productLabel: json['label'] as String,
      productItemDescriptions: json['itemDescriptions'] as String,
      productPrice: (json['price'] as num).toDouble(),
      productQuantity: (json['productQuantity'] as num).toDouble(),
      storeId: json['storeId'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$ProductDataDtoToJson(ProductDataDto instance) =>
    <String, dynamic>{
      'imageUrls': instance.imageList,
      'name': instance.productName,
      'label': instance.productLabel,
      'itemDescriptions': instance.productItemDescriptions,
      'price': instance.productPrice,
      'productQuantity': instance.productQuantity,
      'storeId': instance.storeId,
      'userId': instance.userId,
    };
