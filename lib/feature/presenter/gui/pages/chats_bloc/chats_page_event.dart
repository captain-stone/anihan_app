part of 'chats_page_bloc.dart';

abstract class ChatsPageEvent extends Equatable {
  const ChatsPageEvent();
}

class GetUserListEvent extends ChatsPageEvent {
  final String currentUserId;
  final String? toUserId;

  const GetUserListEvent({required this.currentUserId, this.toUserId});
  @override
  List<Object?> get props => [currentUserId, toUserId];
}

class GetPendingRequestEvent extends ChatsPageEvent {
  final String currentUserId;

  const GetPendingRequestEvent({required this.currentUserId});
  @override
  List<Object?> get props => [currentUserId];
}

class AddingFriendEvent extends ChatsPageEvent {
  final String userUid;
  final String uid;

  const AddingFriendEvent(this.userUid, this.uid);
  @override
  List<Object> get props => [userUid, uid];
}

class SearchFriendEvent extends ChatsPageEvent {
  final String query;

  const SearchFriendEvent(this.query);
  @override
  List<Object> get props => [query];
}
