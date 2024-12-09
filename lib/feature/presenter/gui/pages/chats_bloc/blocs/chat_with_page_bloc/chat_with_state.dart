part of 'chat_with_bloc.dart';

sealed class ChatWithState extends Equatable {
  const ChatWithState();
}

class ChatWithInitial extends ChatWithState {
  @override
  List<Object> get props => [];
}

class ChatWithLoadingState extends ChatWithState {
  @override
  List<Object> get props => [];
}

class ChatWithSuccessState extends ChatWithState {
  final List<MessageData> messages;

  const ChatWithSuccessState(this.messages);
  @override
  List<Object> get props => [messages];
}

class ChatWithErrorState extends ChatWithState {
  final String message;

  const ChatWithErrorState(this.message);
  @override
  List<Object> get props => [message];
}
