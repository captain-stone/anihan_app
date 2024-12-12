part of 'community_chat_bloc.dart';

abstract class CommunityChatState extends Equatable {
  const CommunityChatState();

  @override
  List<Object> get props => [];
}

class CommunityChatInitial extends CommunityChatState {}

class CommunityChatWithLoadingState extends CommunityChatState {
  const CommunityChatWithLoadingState();
  @override
  List<Object> get props => [];
}

class CommunityChatWithSuccessState extends CommunityChatState {
  final CommunityPostDataDto messages;

  const CommunityChatWithSuccessState(this.messages);
  @override
  List<Object> get props => [messages];
}

class CommunityCommentSuccessState extends CommunityChatState {
  final CommentMessageDto messages;

  const CommunityCommentSuccessState(this.messages);
  @override
  List<Object> get props => [messages];
}

class CommunityListChatWithSuccessState extends CommunityChatState {
  final List<CommunityPostDataDto> messages;

  const CommunityListChatWithSuccessState(this.messages);
  @override
  List<Object> get props => [messages];
}

class CommunityChatWithErrorState extends CommunityChatState {
  final String message;

  const CommunityChatWithErrorState(this.message);
  @override
  List<Object> get props => [message];
}
