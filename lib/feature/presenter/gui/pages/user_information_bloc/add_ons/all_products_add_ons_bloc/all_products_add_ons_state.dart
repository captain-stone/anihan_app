part of 'all_products_add_ons_bloc.dart';

abstract class AllProductsAddOnsState extends Equatable {
  const AllProductsAddOnsState();

  @override
  List<Object> get props => [];
}

class AllProductsAddOnsInitial extends AllProductsAddOnsState {}

class AllProductsAddOnsLoadingState extends AllProductsAddOnsState {}

class AllProductSuccessState extends AllProductsAddOnsState {
  final List<ProductEntity> productEntity;

  const AllProductSuccessState(this.productEntity);
}

class AllProductErrorState extends AllProductsAddOnsState {
  final String message;

  const AllProductErrorState(this.message);
  @override
  List<Object> get props => [message];
}
