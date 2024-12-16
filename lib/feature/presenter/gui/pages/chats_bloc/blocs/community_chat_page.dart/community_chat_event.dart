part of 'community_chat_bloc.dart';

abstract class CommunityChatEvent extends Equatable {
  const CommunityChatEvent();

  @override
  List<Object> get props => [];
}

class GetCommunityMessageEvent extends CommunityChatEvent {
  final String communityId;

  const GetCommunityMessageEvent(this.communityId);

  @override
  List<Object> get props => [communityId];
}

class SendCommunityAMessageEvent extends CommunityChatEvent {
  final String communityId;
  final CommunityPostDataDto communityMessage;

  const SendCommunityAMessageEvent(this.communityId, this.communityMessage);

  @override
  List<Object> get props => [communityId, communityMessage];
}

class SendCommentCommunityAMessageEvent extends CommunityChatEvent {
  final String communityId;
  final String commentId;
  final String commentMessage;

  const SendCommentCommunityAMessageEvent(
      this.communityId, this.commentId, this.commentMessage);

  @override
  List<Object> get props => [communityId, commentMessage];
}

class GettingTheProductEvent extends CommunityChatEvent {
  @override
  List<Object> get props => [];
}
