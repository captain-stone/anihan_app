part of 'add_to_cart_bloc.dart';

abstract class AddToCartEvent extends Equatable {
  const AddToCartEvent();
}

class AddProductListToCart extends AddToCartEvent {
  final List<ProductAddCartParams> params;
  final String storeId;

  const AddProductListToCart(this.storeId, this.params);
  @override
  List<Object> get props => [storeId, params];
}

class GetAllCartEvent extends AddToCartEvent {
  const GetAllCartEvent();
  @override
  List<Object> get props => [];
}
