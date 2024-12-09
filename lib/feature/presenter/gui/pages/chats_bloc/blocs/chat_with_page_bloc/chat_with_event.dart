part of 'chat_with_bloc.dart';

abstract class ChatWithEvent extends Equatable {
  const ChatWithEvent();
}

class GetMessageEvent extends ChatWithEvent {
  final String friendUid;

  const GetMessageEvent(this.friendUid);

  @override
  List<Object> get props => [friendUid];
}

class SendAMessageEvent extends ChatWithEvent {
  final String friendUid;
  final String message;

  const SendAMessageEvent(this.friendUid, this.message);

  @override
  List<Object> get props => [friendUid, message];
}
