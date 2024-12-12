part of 'join_community_bloc.dart';

abstract class JoinCommunityEvent extends Equatable {
  const JoinCommunityEvent();
}

class JoinCommunityByOwnerId extends JoinCommunityEvent {
  final String ownerId;
  final JoinCommunity isJoin;

  const JoinCommunityByOwnerId(this.ownerId, this.isJoin);
  @override
  List<Object> get props => [ownerId, isJoin];
}

class GetAllJoinCommunityByOwnerId extends JoinCommunityEvent {
  final String ownerId;

  const GetAllJoinCommunityByOwnerId(this.ownerId);
  @override
  List<Object> get props => [ownerId];
}
