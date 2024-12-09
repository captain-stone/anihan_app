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
