import 'dart:async';

import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/chats_page_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

part 'friends_list_page_event.dart';
part 'friends_list_page_state.dart';

class FriendsListPageBloc
    extends Bloc<FriendsListPageEvent, FriendsListPageState> {
  final logger = Logger();
  final FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late StreamSubscription? _streamSubscription;
  FriendsListPageBloc() : super(FriendsListPageInitial()) {
    on<GetUserListEvent>((event, emit) async {
      emit(FriendsListPageLoadingState());

      var toUser = event.toUserId;
      User? user = auth.currentUser;
      DatabaseReference _friendRef = db.ref("friend_requests");
      DatabaseReference _userRef = db.ref("users");

      try {
        String currentUserId = user!.uid;
        _streamSubscription = _friendRef.onValue.listen((event) async {
          List<Map<String, dynamic>> enrichedFriendRequests = [];
          if (event.snapshot.value != null) {
            final Object? data = event.snapshot.value;
            List<Map<String, dynamic>> friendRequestsData = [];
            (data as Map<dynamic, dynamic>).forEach((key, value) {
              value.forEach((innerKey, innerValue) {
                final entry = {
                  'requestId': key, // Add the request ID

                  'fromUser': innerValue['fromUser'],
                  'status': innerValue['status'],
                  'timestamp': innerValue['timestamp'],
                };
                friendRequestsData.add(entry);
              });
            });

            for (var request in friendRequestsData) {
              // logger.d(request);
              String fromUser = request['fromUser'];
              String requestedId = request['requestId'];
              // logger.d(fromUser);
              // Fetch user information for 'fromUser'
              DataSnapshot userSnapshot =
                  await _userRef.child(requestedId).get();
              if (userSnapshot.exists) {
                Map<String, dynamic> userInfo =
                    Map<String, dynamic>.from(userSnapshot.value as Map);

                // Combine friend request data with user info
                enrichedFriendRequests.add({
                  'requestId': request['requestId'],
                  'requestFrom': fromUser,
                  'status': request['status'],
                  'timestamp': request['timestamp'],
                  'userInfo': userInfo, // Include user's info
                });
              }
            }
          } else if (!emit.isDone) {
            emit(const FriendsListPageErrorState("No friend requests found"));
          }

          if (!emit.isDone) {
            emit(FriendsListPageSuccessState(
              enrichedFriendRequests,
            ));
          }
        }, onDone: () {
          _streamSubscription!.asFuture();
        }, onError: (error) {
          logger.e(error);

          emit(FriendsListPageErrorState(
              "Error occured: (Subscriptions Error): $error"));
        });
        await _streamSubscription!.asFuture();
      } catch (e) {
        emit(FriendsListPageErrorState("Error occured: (Error): $e"));
      }
    });
  }
}
