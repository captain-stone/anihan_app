import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class AddToCartEntity extends AppEntity {
  final String storeId;
  final String cartId;

  final int createAt;
  final double totalPrice;
  final List<AddToCartProductEntity> productEntity;

  AddToCartEntity(
      {required this.storeId,
      required this.cartId,
      required this.createAt,
      required this.totalPrice,
      required this.productEntity});

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'cartId': cartId,
      'createAt': createAt,
      'totalPrice': totalPrice,
      'productEntity': productEntity
          .map((e) => e.toJson())
          .toList(), // Convert nested entities
    };
  }

  @override
  List<Object?> get props =>
      [storeId, cartId, createAt, totalPrice, productEntity];
}

class AllCartEntity extends AppEntity {
  final String storeId;
  final String cartId;

  final int createAt;
  final double totalPrice;
  final List<Map<String, dynamic>> productEntity;

  AllCartEntity(
      {required this.storeId,
      required this.cartId,
      required this.createAt,
      required this.totalPrice,
      required this.productEntity});

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'cartId': cartId,
      'createAt': createAt,
      'totalPrice': totalPrice,
      'productEntity': productEntity.map((map) {
        return map.map((key, value) {
          return MapEntry(key, value.toJson());
        });
      }).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [storeId, cartId, createAt, totalPrice, productEntity];
}

class AddToCartProductEntity extends AppEntity {
  final String name;
  final double price;
  final int quantity;
  final String image;
  // final String productId;

  AddToCartProductEntity(
      this.name, this.price, this.quantity, this.image); //, this.productId);
  Map<String, dynamic> toJson() {
    return {
      'productName': name,
      'quantity': quantity,
      'price': price,
      'image': image,
      // 'productId': productId,
    };
  }

  @override
  List<Object?> get props => [name, price, quantity];
}
