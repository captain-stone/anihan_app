part of 'join_community_cubit.dart';

abstract class JoinCommunityState extends Equatable {
  const JoinCommunityState();
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
  final bool isJoined;
  const JoinCommunitySuccessState(this.isJoined);
  @override
  List<Object> get props => [];
}

class JoinCommunityErrorState extends JoinCommunityState {
  final String message;
  const JoinCommunityErrorState(this.message);
  @override
  List<Object> get props => [];
}
