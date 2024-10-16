import 'dart:typed_data';

import 'package:anihan_app/feature/domain/parameters/params.dart';

class ProductParams extends Params {
  final String productName;
  final String productLabel;
  final double productPrice;
  final String itemDescriptions;
  final List<Uint8List> imageDataList;
  final List<Map<String, dynamic>?>? productVariant;
  // final List<Uint8List?>? product

  ProductParams(
    this.productName,
    this.productLabel,
    this.productPrice,
    this.imageDataList,
    this.itemDescriptions, {
    this.productVariant,
  });

  @override
  List<Object?> get props => [
        productName,
        productLabel,
        productPrice,
        itemDescriptions,
        productVariant,
        imageDataList,
      ];
}
