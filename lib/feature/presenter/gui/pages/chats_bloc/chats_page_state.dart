part of 'chats_page_bloc.dart';

abstract class ChatsPageState extends Equatable {
  const ChatsPageState();
}

class ChatsPageInitial extends ChatsPageState {
  @override
  List<Object> get props => [];
}

class ChatsPageLoadingState extends ChatsPageState {
  @override
  List<Object> get props => [];
}

class ChatsPageSuccessState extends ChatsPageState {
  // final List<FirebaseDataModel> data;
  final Map<String, List<Map<String, dynamic>>> data;

  const ChatsPageSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class ChatsPageSearchSuccessState extends ChatsPageState {
  final List<FirebaseDataModel> data;

  const ChatsPageSearchSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class ChatsPageErrorState extends ChatsPageState {
  final String message;
  const ChatsPageErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class FriendRequestSuccessState extends ChatsPageState {
  final Map<String, dynamic> data;

  const FriendRequestSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class FriendRequestErrorState extends ChatsPageState {
  final String message;

  const FriendRequestErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class AllPendingRequestSuccessState extends ChatsPageState {
  final List<Map<String, dynamic>> data;
  const AllPendingRequestSuccessState(this.data);
  @override
  List<Object> get props => [data];
}
