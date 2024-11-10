part of 'product_add_ons_bloc.dart';

abstract class ProductAddOnsState extends Equatable {
  const ProductAddOnsState();
}

class ProductAddOnsInitial extends ProductAddOnsState {
  @override
  List<Object> get props => [];
}

class ProductAddOnsLoadingState extends ProductAddOnsState {
  @override
  List<Object> get props => [];
}

class ProductAddOnsLoadedState extends ProductAddOnsState {
  @override
  List<Object> get props => [];
}

class ProductSuccessState extends ProductAddOnsState {
  final List<ProductEntity> productEntity;

  const ProductSuccessState(this.productEntity);
  @override
  List<Object> get props => [productEntity];
}

class ProductErrorState extends ProductAddOnsState {
  final String message;

  const ProductErrorState(this.message);
  @override
  List<Object> get props => [message];
}
