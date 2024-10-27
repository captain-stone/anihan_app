part of 'product_category_items_cubit.dart';

class ProductCategoryItemsState extends Equatable {
  const ProductCategoryItemsState();

  @override
  List<Object> get props => [];
}

class ProductCategoryItemsInitial extends ProductCategoryItemsState {}

class ProductCategoryItemsLoadingState extends ProductCategoryItemsState {}

class ProductCategoryItemsLoadedState extends ProductCategoryItemsState {}

class ProductCategoryItemsSuccessState extends ProductCategoryItemsState {
  final List<ProductEntity> productEntity;
  const ProductCategoryItemsSuccessState(this.productEntity);
}

class ProductCategoryItemsErrorState extends ProductCategoryItemsState {
  final String message;
  const ProductCategoryItemsErrorState(this.message);
}
