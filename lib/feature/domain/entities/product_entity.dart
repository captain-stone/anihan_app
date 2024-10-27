import 'dart:typed_data';

import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class ProductEntity extends AppEntity {
  final List<String> productImage;
  final String productName;
  final String productLabel;
  final double productPrice;
  final List<ProductVariantEntity?>? productVariant;
  final String itemDescriptions;
  final String productKey;

  ProductEntity(
    this.productImage,
    this.productName,
    this.productLabel,
    this.productPrice,
    this.itemDescriptions, {
    this.productVariant,
    required this.productKey,
  });

  @override
  List<Object?> get props => [
        productImage,
        productName,
        productLabel,
        productPrice,
        itemDescriptions,
        productKey,
      ];
}

class ProductVariantEntity extends AppEntity {
  final Uint8List? imageData;
  final String? images;
  final String? varianName;
  final String? variantPrice;

  ProductVariantEntity(
      {this.imageData, this.images, this.varianName, this.variantPrice});

  @override
  List<Object?> get props => [imageData, images, varianName, variantPrice];
}
