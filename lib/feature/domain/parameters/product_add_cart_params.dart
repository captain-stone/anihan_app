import 'package:anihan_app/feature/domain/parameters/params.dart';

class ProductAddCartParams extends Params {
  final String name;
  // final String image;
  final double price;
  final int quantity;
  final String? storeId;
  final String? image;

  ProductAddCartParams(
      {required this.name,
      required this.quantity,
      required this.price,
      this.storeId,
      this.image});

  @override
  List<Object?> get props => [name, quantity, price, storeId];
}
