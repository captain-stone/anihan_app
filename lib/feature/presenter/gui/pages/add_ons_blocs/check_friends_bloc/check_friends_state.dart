part of 'check_friends_bloc.dart';

abstract class CheckFriendsState extends Equatable {
  const CheckFriendsState();
}

class CheckFriendsInitial extends CheckFriendsState {
  @override
  List<Object> get props => [];
}

class CheckFriendsLoadingState extends CheckFriendsState {
  @override
  List<Object> get props => [];
}

class CheckFriendsSuccessState extends CheckFriendsState {
  // final FirebaseDataModel data;
  final List<Map<String, dynamic>> data;

  const CheckFriendsSuccessState(this.data);
  @override
  List<Object> get props => [data];
}

class CheckFriendsErrorState extends CheckFriendsState {
  final String message;

  const CheckFriendsErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class AcceptFriendRequestSuccessState extends CheckFriendsState {
  final String message;

  const AcceptFriendRequestSuccessState(this.message);
  @override
  List<Object> get props => [message];
}

class AcceptFriendRequestErrorState extends CheckFriendsState {
  final String message;

  const AcceptFriendRequestErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class GetUserAndStoreNameSuccessState extends CheckFriendsState {
  final Map<String, String> name;

  const GetUserAndStoreNameSuccessState(this.name);
  @override
  List<Object> get props => [name];
}

class GetUserAndStoreNameErrorState extends CheckFriendsState {
  final String message;

  const GetUserAndStoreNameErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class GetUserAndStoreNameLoadingState extends CheckFriendsState {
  const GetUserAndStoreNameLoadingState();
  @override
  List<Object> get props => [];
}
