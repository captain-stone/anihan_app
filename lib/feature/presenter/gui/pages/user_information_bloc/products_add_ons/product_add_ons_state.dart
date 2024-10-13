part of 'product_add_ons_bloc.dart';

abstract class ProductAddOnsState extends Equatable {
  const ProductAddOnsState();

  @override
  List<Object> get props => [];
}

final class ProductAddOnsInitial extends ProductAddOnsState {}

final class ProductAddOnsLoadingState extends ProductAddOnsState {}

class ProductSuccessState extends ProductAddOnsState {
  final List<ProductEntity> productEntity;

  const ProductSuccessState(this.productEntity);
}

class ProductErrorState extends ProductAddOnsState {
  final String message;

  const ProductErrorState(this.message);
  @override
  List<Object> get props => [message];
}
