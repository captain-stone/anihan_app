// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityPostDataDto _$CommunityPostDataDtoFromJson(
        Map<String, dynamic> json) =>
    CommunityPostDataDto(
      id: json['id'] as String?,
      username: json['username'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      like: (json['like'] as num).toInt(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      isCommentVisible: json['isCommentVisible'] as bool? ?? false,
    );

Map<String, dynamic> _$CommunityPostDataDtoToJson(
        CommunityPostDataDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'userId': instance.userId,
      'message': instance.message,
      'like': instance.like,
      'comments': instance.comments,
      'createdAt': instance.createdAt,
      'isCommentVisible': instance.isCommentVisible,
    };

CommentMessageDto _$CommentMessageDtoFromJson(Map<String, dynamic> json) =>
    CommentMessageDto(
      username: json['username'] as String,
      message: json['message'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$CommentMessageDtoToJson(CommentMessageDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'message': instance.message,
      'createdAt': instance.createdAt,
    };
