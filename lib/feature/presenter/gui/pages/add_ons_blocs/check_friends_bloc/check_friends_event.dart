part of 'check_friends_bloc.dart';

abstract class CheckFriendsEvent extends Equatable {
  const CheckFriendsEvent();

  @override
  List<Object> get props => [];
}

class GetFriendListCountEvent extends CheckFriendsEvent {}

class UpdateFriendRequestEvent extends CheckFriendsEvent {
  final String action;
  final String userId;

  const UpdateFriendRequestEvent(this.action, this.userId);

  @override
  List<Object> get props => [action, userId];
}

class GetUserNameAndStoreNameEvent extends CheckFriendsEvent {
  final String storeId;

  const GetUserNameAndStoreNameEvent(this.storeId);
  @override
  List<Object> get props => [storeId];
}
