part of 'notification_page_bloc.dart';

abstract class NotificationPageEvent extends Equatable {
  const NotificationPageEvent();
}

class GetFarmersNotificationsEvent extends NotificationPageEvent {
  final String? uid;

  const GetFarmersNotificationsEvent({this.uid});
  @override
  List<Object?> get props => [uid];
}

class GetCommunityNotification extends NotificationPageEvent {
  // final List<CommunityData> communities;

  const GetCommunityNotification();

  @override
  List<Object?> get props => [];
}

class AcceptCommunityRequestEvent extends NotificationPageEvent {
  final Map<String, dynamic> data;
  const AcceptCommunityRequestEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class DenyCommunityRequestEvent extends NotificationPageEvent {
  final Map<String, dynamic> data;
  const DenyCommunityRequestEvent(this.data);

  @override
  List<Object?> get props => [data];
}
