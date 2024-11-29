part of 'friends_list_page_bloc.dart';

abstract class FriendsListPageState extends Equatable {
  const FriendsListPageState();
}

class FriendsListPageInitial extends FriendsListPageState {
  @override
  List<Object> get props => [];
}

class FriendsListPageLoadingState extends FriendsListPageState {
  @override
  List<Object> get props => [];
}

class FriendsListPageSuccessState extends FriendsListPageState {
  final List<Map<String, dynamic>> data;
  const FriendsListPageSuccessState(this.data);
  @override
  List<Object> get props => [data];
}

class FriendsListPageErrorState extends FriendsListPageState {
  final String message;
  const FriendsListPageErrorState(this.message);
  @override
  List<Object> get props => [message];
}
