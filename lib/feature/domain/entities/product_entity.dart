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
  final String storeId;

  ProductEntity(
    this.productImage,
    this.productName,
    this.productLabel,
    this.productPrice,
    this.itemDescriptions, {
    this.productVariant,
    required this.productKey,
    required this.storeId,
  });

  // factory ProductEntity.fromMap(String key, Map<dynamic, dynamic> data) {
  //   return ProductEntity(
  //     List<String>.from(data['productImage'] ?? []),
  //     data['productName'] as String,
  //     data['productLabel'] as String,
  //     (data['productPrice'] as num).toDouble(),
  //     data['itemDescriptions'] as String,
  //     productKey: key,
  //     storeId: data['storeId'] as String,
  //     productVariant: (data['productVariant'] as List<dynamic>?)
  //         ?.map((variant) => ProductVariantEntity.fromMap(variant))
  //         .toList(),
  //   );
  // }

  @override
  List<Object?> get props => [
        productImage,
        productName,
        productLabel,
        productPrice,
        itemDescriptions,
        productKey,
        storeId,
      ];
}

class ProductVariantEntity extends AppEntity {
  final Uint8List? imageData;
  final String? images;
  final String? varianName;
  final String? variantPrice;

  ProductVariantEntity(
      {this.imageData, this.images, this.varianName, this.variantPrice});

  // factory ProductVariantEntity.fromMap()

  @override
  List<Object?> get props => [imageData, images, varianName, variantPrice];
}
