import 'package:anihan_app/feature/data/models/dto/community_post_dto.dart';
import 'package:anihan_app/feature/domain/entities/community_post_data.dart';
import 'package:anihan_app/feature/domain/entities/message_data.dart';
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/blocs/chat_with_page_bloc/chat_with_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../../common/app_module.dart';
import 'blocs/community_chat_page.dart/community_chat_bloc.dart';

@RoutePage()
class CommunityChatPage extends StatefulWidget {
  final String ownerId;
  final String communityName;
  const CommunityChatPage(
      {required this.ownerId, required this.communityName, super.key});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final _communityBloc = getIt<CommunityChatBloc>();
  final logger = Logger();
  final TextEditingController _tweetController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  List<CommunityPostDataDto> tweets = [
    // CommunityPostDataEntity(
    //   username: 'User1',
    //   userId: 'asdasdasfasdsads',
    //   message: "SADSADASDSAD",
    //   like: 12,
    //   comments: [],
    //   createdAt: DateTime.now().toIso8601String(),
    //   isCommentVisible: false,
    // ),
    // Tweet(
    //   username: 'User2',
    //   handle: '@user2',
    //   tweet: 'Flutter is awesome! #FlutterDev #DartLang',
    //   profilePic: 'https://www.w3schools.com/w3images/avatar2.png',
    //   timeAgo: '2 hours ago',
    //   likes: 20,
    //   retweets: 10,
    //   comments: [],
    //   isCommentVisible: false, // Flag for comment visibility
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _communityBloc.add(GetCommunityMessageEvent(widget.ownerId));
  }

  void _postTweet() {
    final tweetText = _tweetController.text;
    if (tweetText.isNotEmpty) {
      setState(() {
        final message = CommunityPostDataDto(
          username: 'NewUser',
          userId: '@newuser',
          message: tweetText,
          like: 1,
          createdAt: DateTime.now().toIso8601String(),

          comments: [],
          isCommentVisible:
              false, // New tweet, no comment input visible initially
        );

        _communityBloc.add(SendCommunityAMessageEvent(widget.ownerId, message));
        _tweetController.clear();
      });
    }
  }

  void _toggleCommentSection(int tweetIndex) {
    setState(() {
      // Toggle the comment section visibility for the specific tweet
      tweets[tweetIndex].isCommentVisible =
          !tweets[tweetIndex].isCommentVisible;
    });
  }

  void _postComment(int tweetIndex) {
    final commentText = _commentController.text;
    if (commentText.isNotEmpty) {
      setState(() {
        final newComment = CommentMessageDto(
          username: 'NewUser',
          message: commentText,
          createdAt: 'Just now',
        );
        final tweetId = tweets[tweetIndex].id; // Assuming each tweet has an ID
        // _firebaseService.addComment(tweetId, newComment);  // Add the comment to Firebase
        _commentController.clear();
      });
    }
    // final commentText = _commentController.text;
    // if (commentText.isNotEmpty) {
    //   setState(() {
    //     tweets[tweetIndex].comments.add(CommentMessageDto(
    //           username: 'NewUser',
    //           message: commentText,
    //           createdAt: 'Just now',
    //         ));
    //     _commentController.clear();
    //     // Hide the comment field after posting

    //     logger.d(tweetIndex);
    //     tweets[tweetIndex].isCommentVisible = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityChatBloc, CommunityChatState>(
      bloc: _communityBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CommunityListChatWithSuccessState) {
          tweets = [];
          var data = state.messages;

          tweets.addAll(data);
        }
        tweets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.communityName),
            backgroundColor: Colors.blue,
          ),
          body: Column(
            children: [
              // TextField to input new tweet
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _tweetController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'What\'s happening?',
                    border: const OutlineInputBorder(),
                    suffixIcon: TextButton(
                      onPressed: _postTweet,
                      child: const Text("Post"),
                    ),
                  ),
                  maxLines: null, // Allow multiple lines
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: (context, index) {
                    return TweetCard(
                      tweet: tweets[index],
                      onPostComment: () => _postComment(index),
                      commentController: _commentController,
                      onToggleComment: () => _toggleCommentSection(index),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Tweet {
  final String username;
  final String handle;
  final String tweet;
  final String profilePic;
  final String timeAgo;
  final int likes;
  final int retweets;
  final List<Comment> comments;
  bool isCommentVisible; // Flag for visibility of the comment input field

  Tweet({
    required this.username,
    required this.handle,
    required this.tweet,
    required this.profilePic,
    required this.timeAgo,
    required this.likes,
    required this.retweets,
    required this.comments,
    this.isCommentVisible = false,
  });
}

class Comment {
  final String username;
  final String comment;
  final String timeAgo;

  Comment({
    required this.username,
    required this.comment,
    required this.timeAgo,
  });
}

class TweetCard extends StatelessWidget {
  final CommunityPostDataDto tweet;
  final VoidCallback onPostComment;
  final TextEditingController commentController;
  final VoidCallback onToggleComment;

  const TweetCard({
    required this.tweet,
    required this.onPostComment,
    required this.commentController,
    required this.onToggleComment,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(tweet.createdAt);

    // Format the date and time separately
    String formattedDate = DateFormat("MMMM d, yyyy")
        .format(parsedDate); // e.g., December 13, 2024
    String formattedTime = DateFormat("h:mma").format(parsedDate);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture and user details
            Row(
              children: [
                // CircleAvatar(
                //   backgroundImage: NetworkImage(tweet.profilePic),
                //   radius: 20,
                // ),
                // const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tweet.username,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(tweet.userId,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formattedDate,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 8)),
                    Text(formattedTime,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 8)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Tweet content
            Text(tweet.message),
            const SizedBox(height: 12),
            // Engagement buttons (like, retweet, comment)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // _buildEngagementButton(
                //     Icons.thumb_up_alt_outlined, '${tweet.likes}'),
                // _buildEngagementButton(Icons.repeat, '${tweet.retweets}'),
                _buildEngagementButton(
                    Icons.comment_outlined, '${tweet.comments.length}'),
                IconButton(
                  icon: Icon(Icons.comment_outlined),
                  onPressed:
                      onToggleComment, // Toggle comment section visibility
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Comments section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display comments
                ...tweet.comments.map((comment) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 15),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(comment.message),
                            Text(comment.createdAt,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                // Show TextField only if `isCommentVisible` is true
                if (tweet.isCommentVisible)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 15),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: onPostComment,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 5),
        Text(count, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
