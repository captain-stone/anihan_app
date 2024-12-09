part of 'notification_page_bloc.dart';

abstract class NotificationPageState extends Equatable {
  const NotificationPageState();
}

class NotificationPageInitial extends NotificationPageState {
  @override
  List<Object> get props => [];
}

class NotificationPageLoadingState extends NotificationPageState {
  @override
  List<Object> get props => [];
}

class NotificationPageSuccessState extends NotificationPageState {
  final Map<String, dynamic> data;
  const NotificationPageSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class NotificationPageErrorState extends NotificationPageState {
  final String message;
  const NotificationPageErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class NotificationCommunitiesLoadingState extends NotificationPageState {
  // final List<CommunityData> communities;
  const NotificationCommunitiesLoadingState();
  @override
  List<Object> get props => [];
}

//
class NotificationCommunitiesSuccessState extends NotificationPageState {
  final List<CommunityData> communities;
  const NotificationCommunitiesSuccessState(this.communities);
  @override
  List<Object> get props => [communities];
}

class NotificationCommunitiesErrorState extends NotificationPageState {
  // final List<CommunityData> communities;
  final String message;
  const NotificationCommunitiesErrorState(this.message);

  @override
  List<Object> get props => [];
}
