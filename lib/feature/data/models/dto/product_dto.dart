import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  final String productName;
  final int productprice;
  final String productImamgeData;

  ProductDto({
    required this.productName,
    required this.productprice,
    required this.productImamgeData,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}

@JsonSerializable()
class ProductVariantDto {
  final Map<String, ProductDto> productVariantId;

  ProductVariantDto({required this.productVariantId});

  factory ProductVariantDto.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVariantDtoToJson(this);
}
