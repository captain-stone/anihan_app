import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductVariantDto {
  final String? variantName;
  final String? variantPrice;
  final String? variantImages;

  ProductVariantDto({this.variantName, this.variantPrice, this.variantImages});

  factory ProductVariantDto.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVariantDtoToJson(this);
}

@JsonSerializable()
class ProductDataDto {
  @JsonKey(name: "imageUrls")
  final List<String?> imageList;
  @JsonKey(name: "name")
  final String productName;
  @JsonKey(name: "label")
  final String productLabel;
  @JsonKey(name: "itemDescriptions")
  final String productItemDescriptions;
  @JsonKey(name: "price")
  final double productPrice;
  final String? storeId;
  final String? userId;
  // final List<Map<String, dynamic>?>? productVariantDtoList;

  ProductDataDto({
    required this.imageList,
    required this.productName,
    required this.productLabel,
    required this.productItemDescriptions,
    required this.productPrice,
    // this.productVariantDtoList,
    this.storeId,
    this.userId,
  });

  factory ProductDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDataDtoToJson(this);

  static Map<String, dynamic> customToJson(ProductDataDto dto,
      List<Map<String, dynamic>> productVariantData, String userId) {
    final data = dto.toJson();

    // data["storeId"] = true;
    data["storeId-$userId-id"] = true;
    data["variant-$userId-id"] = productVariantData;

    return data;
  }
}
