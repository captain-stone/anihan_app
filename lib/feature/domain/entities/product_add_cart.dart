import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class ProductAddCart extends AppEntity {
  final String userId;
  final String cartId;
  final String name;
  final String image;
  final double price;

  ProductAddCart(this.userId, this.cartId,
      {required this.name, required this.image, required this.price});

  @override
  List<Object?> get props => [userId, cartId, name, image, price];
}
