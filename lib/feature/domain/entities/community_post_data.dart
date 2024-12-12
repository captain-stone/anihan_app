// import 'package:anihan_app/feature/domain/entities/app_entity.dart';

// ignore_for_file: must_be_immutable

import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class CommunityPostDataEntity extends AppEntity {
  final String username;
  final String userId;
  final String message;
  final int like;
  final List<CommentMessageEntity> comments;
  final String createdAt;
  bool isCommentVisible;

  CommunityPostDataEntity({
    required this.username,
    required this.userId,
    required this.message,
    required this.like,
    required this.comments,
    required this.createdAt,
    this.isCommentVisible = false,
  });

  @override
  List<Object?> get props =>
      [username, message, like, comments, createdAt, isCommentVisible];
}

class CommentMessageEntity extends AppEntity {
  final String username;
  final String message;
  final String createdAt;

  CommentMessageEntity(
      {required this.username, required this.message, required this.createdAt});

  @override
  List<Object?> get props => [username, message, createdAt];
}
