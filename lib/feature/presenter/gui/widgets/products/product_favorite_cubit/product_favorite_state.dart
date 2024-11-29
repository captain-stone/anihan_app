part of 'product_favorite_cubit.dart';

abstract class ProductFavoriteState extends Equatable {
  const ProductFavoriteState();
}

class ProductFavoriteInitial extends ProductFavoriteState {
  @override
  List<Object> get props => [];
}

class ProductFavoriteLoadingState extends ProductFavoriteState {
  @override
  List<Object> get props => [];
}

class ProductFavoriteSuccessState extends ProductFavoriteState {
  final Map<String, dynamic> successMessage;
  const ProductFavoriteSuccessState(this.successMessage);
  @override
  List<Object> get props => [successMessage];
}

class ProducFavoriteDataState extends ProductFavoriteState {
  final List<String> data;
  const ProducFavoriteDataState(this.data);
  @override
  List<Object> get props => [data];
}

class ProductFavoriteErrorState extends ProductFavoriteState {
  final String message;
  const ProductFavoriteErrorState(this.message);
  @override
  List<Object> get props => [message];
}
