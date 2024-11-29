part of 'friends_list_page_bloc.dart';

abstract class FriendsListPageEvent extends Equatable {
  const FriendsListPageEvent();
}

class GetUserListEvent extends FriendsListPageEvent {
  final String? toUserId;

  const GetUserListEvent({this.toUserId});
  @override
  List<Object?> get props => [toUserId];
}
