import 'package:json_annotation/json_annotation.dart';

part 'community_post_dto.g.dart';

@JsonSerializable()
class CommunityPostDataDto {
  final String? id;
  final String username;
  final String userId;
  final String message;
  final int like;
  final List<CommentMessageDto> comments;
  final String createdAt;
  bool isCommentVisible;

  CommunityPostDataDto({
    this.id,
    required this.username,
    required this.userId,
    required this.message,
    required this.like,
    required this.comments,
    required this.createdAt,
    this.isCommentVisible = false,
  });

  CommunityPostDataDto copyWith({String? id}) {
    return CommunityPostDataDto(
      id: id ?? this.id,
      username: username,
      userId: userId,
      message: message,
      like: like,
      comments: comments,
      createdAt: createdAt,
    );
  }

  // Map<String, dynamic> toMap() => _$CommunityPostDataDtoToJson(this);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'userId': userId,
      'message': message,
      'like': like,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'createdAt': createdAt,
    };
  }

  factory CommunityPostDataDto.fromMap(Map<String, dynamic> map) {
    return CommunityPostDataDto(
      username: map['username'],
      userId: map['userId'],
      message: map['message'],
      createdAt: map['createdAt'],
      like: map['like'],
      comments: (map['comments'] as List<dynamic>?)
              ?.map((commentMap) => CommentMessageDto.fromMap(commentMap))
              .toList() ??
          [],
    );
  }

  factory CommunityPostDataDto.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityPostDataDtoToJson(this);

  // @override
  // List<Object?> get props =>
  //     [username, message, like, comments, createdAt, isCommentVisible];

  // @override
  // CommunityPostDataEntity toEntity() => CommunityPostDataEntity(username: username, userId: userId, message: message, like: like, comments: comments, createdAt: createdAt)
}

@JsonSerializable()
class CommentMessageDto {
  final String username;
  final String message;
  final String createdAt;

  CommentMessageDto(
      {required this.username, required this.message, required this.createdAt});

  Map<String, dynamic> toMap() => _$CommentMessageDtoToJson(this);

  factory CommentMessageDto.fromMap(Map<String, dynamic> map) {
    return _$CommentMessageDtoFromJson(
        map); // Use generated function from json_serializable
  }
  factory CommentMessageDto.fromJson(Map<String, dynamic> json) =>
      _$CommentMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommentMessageDtoToJson(this);
  @override
  List<Object?> get props => [username, message, createdAt];
}
