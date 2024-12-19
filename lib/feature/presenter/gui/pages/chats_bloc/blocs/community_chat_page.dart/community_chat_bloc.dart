import 'dart:async';

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/community_service_api.dart';
import 'package:anihan_app/feature/data/models/api/user_information_service_api.dart';
import 'package:anihan_app/feature/data/models/dto/community_post_dto.dart';
import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/community_chat_page.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../../../domain/entities/message_data.dart';
import '../../../../../../services/generate_hash_key.dart';

part 'community_chat_event.dart';
part 'community_chat_state.dart';

@injectable
class CommunityChatBloc extends Bloc<CommunityChatEvent, CommunityChatState> {
  final CommunityServiceApi _serviceApi = CommunityServiceApi();
  final UserInformationServiceApi _userInformationServiceApi =
      UserInformationServiceApi();
  final FirebaseDatabase db = FirebaseDatabase.instance;
  final Logger logger = Logger();
  late final StreamSubscription _streamSubscription;
  CommunityChatBloc() : super(CommunityChatInitial()) {
    on<SendCommunityAMessageEvent>((event, emit) async {
      emit(CommunityChatWithLoadingState());
      final String communityId = event.communityId;
      var completeId = 'community-id-$communityId';
      final message = event.communityMessage;
      User? currentUser = FirebaseAuth.instance.currentUser;
      String convoId = getConversationIdHash("convo-id-", completeId);
      var nameDto = await _userInformationServiceApi
          .getUserInformationById(currentUser!.uid);

      // String date = message.createdAt;

      // DateTime newDate = DateTime.parse(date);

      // String formattedDate = DateFormat("MMMM d, yyyy, h:mma").format(newDate);

      var finalMessage = CommunityPostDataDto(
          username: nameDto.displayName,
          userId: currentUser.uid,
          message: message.message,
          like: message.like,
          comments: message.comments,
          createdAt: message.createdAt);
      var result = await _serviceApi.saveTweet(convoId, finalMessage);

      Status status = result.status;
      if (status != Status.error) {
        var data = result.data;

        if (data != null) {
          emit(CommunityChatWithSuccessState(data));
        } else {
          emit(CommunityChatWithErrorState(result.message!));
        }
      } else {
        emit(CommunityChatWithErrorState(result.message!));
      }
      //COMMENT FROM SEND MESSAGE
      // final String communityId = event.communityId;
      // var completeId = 'community-id-$communityId';
      // final String message = event.message;
      // User? currentUser = FirebaseAuth.instance.currentUser;
      // String convoId = getConversationIdHash("convo-id-", completeId);
      // DatabaseReference _ref = db.ref('chats/community/convo-id-$convoId');
      // try {
      //   DatabaseReference _pushRef = _ref.push();
      //   var chatData = {
      //     'message': message,
      //     "sender": currentUser?.uid ?? "Anonymous",
      //     "timestamp": DateTime.now().toIso8601String()
      //   };
      //   _pushRef.set(chatData);
      // } catch (e) {
      //   logger.e(e);
      //   emit(const CommunityChatWithErrorState(
      //       "There's an error sending a message"));
      // }
    });

    on<SendCommentCommunityAMessageEvent>((event, emit) async {
      emit(CommunityChatWithLoadingState());
      final String communityId = event.communityId;
      final String commentId = event.commentId;
      var completeId = 'community-id-$communityId';
      final message = event.commentMessage;
      User? currentUser = FirebaseAuth.instance.currentUser;
      String convoId = getConversationIdHash("convo-id-", completeId);
      var nameDto = await _userInformationServiceApi
          .getUserInformationById(currentUser!.uid);

      // String date = message.createdAt;

      // DateTime newDate = DateTime.parse(date);

      // String formattedDate = DateFormat("MMMM d, yyyy, h:mma").format(newDate);

      var finalMessage = CommentMessageDto(
          username: nameDto.displayName,
          message: message,
          createdAt: DateTime.now().toIso8601String());
      var result =
          await _serviceApi.addComment(convoId, commentId, finalMessage);

      Status status = result.status;
      if (status != Status.error) {
        var data = result.data;

        if (data != null) {
          emit(CommunityCommentSuccessState(data));
        } else {
          emit(CommunityChatWithErrorState(result.message!));
        }
      } else {
        emit(CommunityChatWithErrorState(result.message!));
      }
    });

    on<GetCommunityMessageEvent>(
      (event, emit) async {
        emit(const CommunityChatWithLoadingState());

        var communityId = event.communityId;
        var completeId = 'community-id-$communityId';
        String convoId = getConversationIdHash("convo-id-", completeId);
        DatabaseReference _ref = db.ref('chats/community/$convoId');
        try {
          _streamSubscription = _ref.onValue.listen((event) {
            List<CommunityPostDataDto> messages = [];
            if (event.snapshot.value != null) {
              final data = event.snapshot.value as Map<dynamic, dynamic>;
              // logger.d(data);
              data.forEach((key, value) {
                if (value is Map<dynamic, dynamic>) {
                  // Convert each Firebase entry to a Tweet model
                  logger.d(value);

                  messages.add(CommunityPostDataDto.fromMap(
                      Map<String, dynamic>.from(value)));
                }
              });
            }
            logger.d(messages[0].id);

            if (!emit.isDone) {
              emit(CommunityListChatWithSuccessState(messages));
            }
          }, onDone: () {
            _streamSubscription.asFuture();
          }, onError: (error) {
            if (!emit.isDone) {
              emit(CommunityChatWithErrorState("Error Occurred: $error"));
            }
          });
          await _streamSubscription.asFuture();
        } catch (e) {
          emit(CommunityChatWithErrorState(
            e.toString(),
          ));
        }
      },
    );

    //  on<GetCommentCommunityMessageEvent>(
    //   (event, emit) async {
    //     emit(const CommunityChatWithLoadingState());

    //     var communityId = event.communityId;
    //     var completeId = 'community-id-$communityId';
    //     String convoId = getConversationIdHash("convo-id-", completeId);
    //     DatabaseReference _ref = db.ref('chats/community/$convoId');
    //     try {
    //       _streamSubscription = _ref.onValue.listen((event) {
    //         List<CommunityPostDataDto> messages = [];
    //         if (event.snapshot.value != null) {
    //           final data = event.snapshot.value as Map<dynamic, dynamic>;
    //           // logger.d(data);
    //           data.forEach((key, value) {
    //             if (value is Map<dynamic, dynamic>) {
    //               // Convert each Firebase entry to a Tweet model
    //               logger.d(value);

    //               messages.add(CommunityPostDataDto.fromMap(
    //                   Map<String, dynamic>.from(value)));
    //             }
    //           });
    //         }

    //         if (!emit.isDone) {
    //           emit(CommunityListChatWithSuccessState(messages));
    //         }
    //       }, onDone: () {
    //         _streamSubscription.asFuture();
    //       }, onError: (error) {
    //         if (!emit.isDone) {
    //           emit(CommunityChatWithErrorState("Error Occurred: $error"));
    //         }
    //       });
    //       await _streamSubscription.asFuture();
    //     } catch (e) {
    //       emit(CommunityChatWithErrorState(
    //         e.toString(),
    //       ));
    //     }
    //   },
    // );

    on<GettingTheProductEvent>((event, emit) async {
      List<String> imageUrls = [];
      emit(const CommunityChatWithLoadingState());
      FirebaseAuth auth = FirebaseAuth.instance;

      User? user = auth.currentUser;
      List<Map<String, dynamic>> productList = [];

      try {
        final DatabaseReference _ref =
            FirebaseDatabase.instance.ref("products/product-id${user!.uid}");

        DataSnapshot snapshot = await _ref.get();

        if (snapshot.exists) {
          var object = snapshot.value as Map?;
          // logger.d(object);
          if (object != null) {
            object.forEach((key, value) {
              var data = {
                "name": value['name'],
                "itemDescriptions": value['itemDescriptions'],
                "price": value['price'],
              };

              productList.add(data);
            });
          }

          if (productList.isNotEmpty) {
            emit(GettingProductSuccessState(productList));
          } else {
            emit(const CommunityChatWithErrorState("No products"));
          }
        } else {
          emit(const CommunityChatWithErrorState("No saved products"));
        }
      } catch (e) {
        logger.e(e.toString());
        emit(CommunityChatWithErrorState("Error Occured: $e"));
      }
    });
  }
}
