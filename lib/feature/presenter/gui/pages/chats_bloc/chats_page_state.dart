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
  final List<FirebaseDataModel> data;

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
