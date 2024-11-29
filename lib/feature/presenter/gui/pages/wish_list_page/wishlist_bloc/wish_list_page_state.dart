part of 'wish_list_page_bloc.dart';

abstract class WishListPageState extends Equatable {
  const WishListPageState();
}

class WishListPageInitial extends WishListPageState {
  @override
  List<Object> get props => [];
}

class WishListPageLoadingState extends WishListPageState {
  const WishListPageLoadingState();
  @override
  List<Object> get props => [];
}

class WishListPageSuccessState extends WishListPageState {
  final List<ProductEntity> productEntityList;

  const WishListPageSuccessState(this.productEntityList);

  @override
  List<Object> get props => [productEntityList];
}

class WishListPageErrorState extends WishListPageState {
  final String message;
  const WishListPageErrorState(this.message);
  @override
  List<Object> get props => [message];
}
