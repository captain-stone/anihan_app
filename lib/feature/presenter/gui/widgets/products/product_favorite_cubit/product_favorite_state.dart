part of 'product_favorite_cubit.dart';

sealed class ProductFavoriteState extends Equatable {
  const ProductFavoriteState();

  @override
  List<Object> get props => [];
}

class ProductFavoriteInitial extends ProductFavoriteState {}

class ProductFavoriteLoadingState extends ProductFavoriteState {}

class ProductFavoriteSuccessState extends ProductFavoriteState {
  final Map<String, dynamic> successMessage;
  const ProductFavoriteSuccessState(this.successMessage);
}

class ProductFavoriteErrorState extends ProductFavoriteState {
  final String message;
  const ProductFavoriteErrorState(this.message);
}
