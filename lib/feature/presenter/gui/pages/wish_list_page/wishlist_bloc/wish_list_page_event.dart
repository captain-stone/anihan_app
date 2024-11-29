part of 'wish_list_page_bloc.dart';

abstract class WishListPageEvent extends Equatable {
  const WishListPageEvent();
}

class GetWishListEvent extends WishListPageEvent {
  @override
  List<Object> get props => [];
}
