import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/dto/community_post_dto.dart';
import 'package:firebase_database/firebase_database.dart';

class CommunityServiceApi {
  // Save a tweet to Firebase
  Future<ApiResult<CommunityPostDataDto>> saveTweet(
      String convoId, CommunityPostDataDto communityMessage) async {
    try {
      final DatabaseReference _tweetsRef =
          FirebaseDatabase.instance.ref("chats/community/$convoId");

      final tweetRef = _tweetsRef.push();
      final generatedKey = tweetRef.key;

      final communityMessageWithId =
          communityMessage.copyWith(id: generatedKey);

      await tweetRef.set(communityMessageWithId.toMap());

      return ApiResult.success(communityMessage);
    } catch (error) {
      return ApiResult.error(error.toString());
    }
  }

  // Add a comment to a specific tweet
  Future<ApiResult<CommentMessageDto>> addComment(
      String convoId, String tweetId, CommentMessageDto comment) async {
    try {
      final DatabaseReference _tweetsRef =
          FirebaseDatabase.instance.ref("chats/community/$convoId");

      final tweetRef = _tweetsRef
          .child(tweetId)
          .child('comments')
          .push(); // Push a new comment
      await tweetRef.set(comment.toMap());

      return ApiResult.success(comment);
    } on Exception catch (e) {
      return ApiResult.error(e.toString());
    }
  }
}
