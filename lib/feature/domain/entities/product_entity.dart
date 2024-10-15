import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class ProductEntity extends AppEntity {
  final List<String> productImage;
  final String productName;
  final String productLabel;
  final double productPrice;
  final List<Map<String, dynamic>?>? productVariant;
  final String itemDescriptions;

  ProductEntity(
    this.productImage,
    this.productName,
    this.productLabel,
    this.productPrice,
    this.itemDescriptions, {
    this.productVariant,
  });

  @override
  List<Object?> get props => [
        productImage,
        productName,
        productLabel,
        productPrice,
        itemDescriptions,
      ];
}
