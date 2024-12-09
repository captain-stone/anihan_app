import 'dart:typed_data';

import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/domain/parameters/params.dart';

class ProductParams extends Params {
  final String productName;
  final String productLabel;
  final double productPrice;
  final double productQuantity;
  final String itemDescriptions;
  final List<Uint8List> imageDataList;
  final List<ProductVariantEntity?>? productVariant;
  // final List<Uint8List?>? product

  ProductParams(
    this.productName,
    this.productLabel,
    this.productPrice,
    this.productQuantity,
    this.imageDataList,
    this.itemDescriptions, {
    this.productVariant,
  });

  @override
  List<Object?> get props => [
        productName,
        productLabel,
        productPrice,
        productQuantity,
        itemDescriptions,
        productVariant,
        imageDataList,
      ];
}
