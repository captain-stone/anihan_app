part of 'join_community_bloc.dart';

sealed class JoinCommunityState extends Equatable {
  const JoinCommunityState();

  @override
  List<Object> get props => [];
}

class JoinCommunityInitial extends JoinCommunityState {
  @override
  List<Object> get props => [];
}

class JoinCommunityLoadingState extends JoinCommunityState {
  @override
  List<Object> get props => [];
}

class JoinCommunitySuccessState extends JoinCommunityState {
  final Map<String, dynamic> isJoined;
  const JoinCommunitySuccessState(this.isJoined);
  @override
  List<Object> get props => [isJoined];
}

class JoinCommunityErrorState extends JoinCommunityState {
  final String message;
  const JoinCommunityErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class GetAllJoinedCommunitySuccessState extends JoinCommunityState {
  final Map<String, dynamic> dataJoinCom;
  const GetAllJoinedCommunitySuccessState(this.dataJoinCom);
  @override
  List<Object> get props => [dataJoinCom];
}

class GetAllJoinedCommunityErrorState extends JoinCommunityState {
  final String message;
  const GetAllJoinedCommunityErrorState(this.message);
  @override
  List<Object> get props => [message];
}
