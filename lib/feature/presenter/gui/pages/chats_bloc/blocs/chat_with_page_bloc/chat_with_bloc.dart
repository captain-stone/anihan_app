// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:anihan_app/feature/domain/entities/message_data.dart';
import 'package:anihan_app/feature/services/generate_hash_key.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'chat_with_event.dart';
part 'chat_with_state.dart';

@injectable
class ChatWithBloc extends Bloc<ChatWithEvent, ChatWithState> {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  final Logger logger = Logger();
  late final StreamSubscription _streamSubscription;
  ChatWithBloc() : super(ChatWithInitial()) {
    // on<ChatWithEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    //SEND A MESSAGE EVENT
    on<SendAMessageEvent>(
      (event, emit) {
        emit(ChatWithLoadingState());
        final String friendUid = event.friendUid;
        final String message = event.message;
        User? currentUser = FirebaseAuth.instance.currentUser;
        String convoId =
            getConversationIdHash(currentUser?.uid ?? '', friendUid);
        DatabaseReference _ref = db.ref('chats/uid/convo-id-$convoId');
        try {
          DatabaseReference _pushRef = _ref.push();

          var chatData = {
            "message": message,
            "sender": currentUser?.uid ?? "",
            "timestamp": DateTime.now().toIso8601String()
          };

          _pushRef.set(chatData);

          // _streamSubscription = _ref.onValue.listen(
          //   (event) {
          //     // var chatData = {"message": message};

          //   },
          //   onDone: () => _streamSubscription.asFuture(),
          // );
        } catch (e) {
          logger.e(e);
        }
      },
    );

    on<GetMessageEvent>(
      (event, emit) async {
        emit(ChatWithLoadingState());
        var friendId = event.friendUid;
        User? currentUser = FirebaseAuth.instance.currentUser;

        String convoId =
            getConversationIdHash(currentUser?.uid ?? '', friendId);
        DatabaseReference _ref = db.ref('chats/uid/convo-id-$convoId');

        try {
          _streamSubscription = _ref.onValue.listen((event) {
            List<MessageData> messages = [];
            if (event.snapshot.value != null) {
              final Object? data = event.snapshot.value;
              // logger.d(data);
              (data as Map<dynamic, dynamic>).forEach((key, value) {
                if (value is Map<dynamic, dynamic>) {
                  messages.add(MessageData(
                      message: value["message"],
                      sender: value["sender"],
                      datetime: DateTime.parse(value['timestamp'])));
                }
              });
            }

            if (!emit.isDone) {
              emit(ChatWithSuccessState(messages));
            }
          }, onDone: () {
            _streamSubscription.asFuture();
          }, onError: (error) {
            if (!emit.isDone) {
              emit(ChatWithErrorState("Error Occurred: $error"));
            }
          });
          await _streamSubscription.asFuture();
        } catch (e) {
          emit(ChatWithErrorState(
            e.toString(),
          ));
        }
      },
    );
  }
}
