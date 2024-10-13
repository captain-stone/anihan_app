import 'package:anihan_app/feature/domain/parameters/params.dart';

class ProductParams extends Params {
  final String productName;
  final String productLabel;
  final double productPrice;
  final List<Map<String, dynamic>?>? productVariant;
  final String itemDescriptions;

  ProductParams(
    this.productName,
    this.productLabel,
    this.productPrice,
    this.itemDescriptions, {
    this.productVariant,
  });

  @override
  List<Object?> get props => [
        productName,
        productLabel,
        productPrice,
        itemDescriptions,
        productVariant
      ];
}
