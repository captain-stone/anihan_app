part of 'product_update_cubit.dart';

abstract class ProductUpdateState extends Equatable {
  const ProductUpdateState();

  @override
  List<Object> get props => [];
}

class ProductUpdateInitial extends ProductUpdateState {}

class ProductUpdateLoadingState extends ProductUpdateState {}

class ProductUpdateSuccessState extends ProductUpdateState {}

class ProductUpdateErrorState extends ProductUpdateState {
  final String message;

  const ProductUpdateErrorState(this.message);
}
