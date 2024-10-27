part of 'all_products_add_ons_bloc.dart';

abstract class AllProductsAddOnsState extends Equatable {
  const AllProductsAddOnsState();

  @override
  List<Object> get props => [];
}

class AllProductsAddOnsInitial extends AllProductsAddOnsState {
  @override
  List<Object> get props => [];
}

class AllProductsAddOnsLoadingState extends AllProductsAddOnsState {
  @override
  List<Object> get props => [];
}

class AllProductSuccessState extends AllProductsAddOnsState {
  final List<ProductEntity> productEntity;

  const AllProductSuccessState(this.productEntity);
  @override
  List<Object> get props => [productEntity];
}

class AllProductErrorState extends AllProductsAddOnsState {
  final String message;

  const AllProductErrorState(this.message);

  @override
  List<Object> get props => [message];
}
