// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:anihan_app/feature/data/models/api/friend_request_api.dart';
import 'package:anihan_app/feature/domain/entities/community_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../../../../../../common/api_result.dart';
import '../../../../../../data/models/api/firebase_model.dart';

part 'chats_page_event.dart';
part 'chats_page_state.dart';

@injectable
class ChatsPageBloc extends Bloc<ChatsPageEvent, ChatsPageState> {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  final Logger logger = Logger();
  late StreamSubscription? _subscription;

  ChatsPageBloc() : super(ChatsPageInitial()) {
    on<GetChatUserListEvent>((event, emit) async {
      emit(ChatsPageLoadingState());

      var currentUserId = event.currentUserId;
      var toUser = event.toUserId;

      DatabaseReference friendRequestsRef =
          db.ref("friend_requests"); //.child(currentUserId);
      DatabaseReference usersRef = db.ref("users");

      try {
        _subscription = friendRequestsRef.onValue.listen((event) async {
          List<Map<String, dynamic>> enrichedFriendRequests = [];
          List<Map<String, dynamic>> friendSuggestions = [];

          // 1. Fetch Friend Requests
          if (event.snapshot.value != null) {
            final Object? data = event.snapshot.value;

            List<Map<String, dynamic>> friendRequestsData = [];
            (event.snapshot.value as Map<dynamic, dynamic>)
                .forEach((key, value) {
              value.forEach((innerKey, innerValue) {
                // Create a new map for each entry
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
                  await usersRef.child(requestedId).get();
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
            emit(const ChatsPageErrorState("No friend requests found"));
          }

          DataSnapshot usersSnapshot = await usersRef.get();
          if (usersSnapshot.exists) {
            Map<dynamic, dynamic> allUsers = usersSnapshot.value as Map;
            // logger.d(enrichedFriendRequests.map())
            // logger.d(enrichedFriendRequests);

            Set<String> friendRequestUserIds = enrichedFriendRequests
                .map((request) {
                  if (request['requestFrom'] == currentUserId) {
                    return request['requestId'];
                  }
                })
                .whereType<String>()
                .toSet();

            friendSuggestions = allUsers.entries
                .where((entry) =>
                    !friendRequestUserIds.contains(entry.key) &&
                    entry.key != currentUserId)
                .map((entry) => {
                      'userId': entry.key,
                      'userInfo': Map<String, dynamic>.from(
                          entry.value), // User details like name, etc.
                    })
                .toList();
          }

          if (!emit.isDone) {
            emit(ChatsPageSuccessState({
              'friendRequests': enrichedFriendRequests,
              'friendSuggestions': friendSuggestions,
            }));
          }
        }, onDone: () {
          _subscription!.asFuture();
        }, onError: (error) {
          logger.e(error);
          emit(ChatsPageErrorState("Error Occurred: $error"));
        });

        await _subscription!.asFuture();
      } catch (e) {
        logger.e("Failed to load friend requests and suggestions: $e");
        emit(const ChatsPageErrorState("Error loading data"));
      }

      // DatabaseReference _refs = db.ref("users/");

      // try {
      //   _subscription = _refs.onValue.listen((event) {
      //     if (event.snapshot.value == null) {
      //       if (!emit.isDone) {
      //         emit(const ChatsPageErrorState("No data saved"));
      //       }
      //       _subscription?.isPaused;
      //     } else {
      //       // logger.d(event.snapshot.value);

      //       var data = (event.snapshot.value as Map<dynamic, dynamic>)
      //           .entries
      //           .map((entry) => FirebaseDataModel(
      //               key: entry.key,
      //               value: Map<String, dynamic>.from(entry.value)))
      //           .toList();

      //       if (!emit.isDone) {
      //         emit(ChatsPageSuccessState(data));
      //         _subscription?.isPaused;
      //       }

      //       //data is storename, storeaddress, and isApproved
      //     }
      //   }, onDone: () {
      //     _subscription!.asFuture();
      //   }, onError: (error) {
      //     logger.e(error);
      //     emit(ChatsPageErrorState("Error Occured: $error"));
      //   });
      //   await _subscription!.asFuture();
      // } catch (e) {
      //   logger.d(e);
      //   emit(ChatsPageErrorState("Error Occured: $e"));
      // }
    });

    on<AddingFriendEvent>((event, emit) async {
      emit(ChatsPageLoadingState());

      FriendRequestService friendRequestService = FriendRequestService();

      var data = await friendRequestService.sendFriendRequest(
          event.uid, event.userUid);

      var status = data.status;

      if (status == Status.success) {
        if (data.data != null) {
          emit(FriendRequestSuccessState(data.data!));
        } else {
          emit(FriendRequestErrorState(data.message!));
        }
      } else {
        emit(FriendRequestErrorState(data.message!));
      }
    });

    on<SearchFriendEvent>((event, emit) async {
      emit(ChatsPageLoadingState());
      DatabaseReference _refs = db.ref("users/");
      _refs.child(event.query);

      var query = event.query.toLowerCase();

      try {
        await _refs.once().then((snapShot) {
          if (snapShot.snapshot.exists) {
            var data = snapShot.snapshot.value as Map<dynamic, dynamic>;
            List<FirebaseDataModel> matchedUsers = [];
            data.forEach((key, value) {
              String fullName = value['fullName'].toString().toLowerCase();

              if (value is Map) {
                var valueData =
                    value.map((key, val) => MapEntry(key.toString(), val));
                if (fullName.contains(query)) {
                  // logger.d()
                  // logger.d(key.toString());
                  // logger.d(valueData);
                  // logger.d(value as Map<String, dynamic>);

                  matchedUsers.add(
                      FirebaseDataModel(key: key.toString(), value: valueData));
                  // logger.e("Found user: $fullName with ID: $key");
                }
              }
            });

            if (matchedUsers.isEmpty) {
              // logger.f("No user found matching: $query");

              emit(ChatsPageErrorState("No user found matching: $query"));
            } else {
              logger.d("Matched users: $matchedUsers");

              emit(ChatsPageSearchSuccessState(matchedUsers));
            }
          }
        });

        // _refs.orderByChild('fullName').equalTo(query).once().then((snapShot) {
        //   if (snapShot.snapshot.exists) {
        //     var data = snapShot.snapshot.value as Map;
        //     data.forEach((key, value) {
        //       logger.e("Found user: ${value['fullName']} with ID: $key");
        //     });
        //   } else {
        //     logger.f("ASDASDASDASD");
        //   }
        // });
      } catch (e) {
        logger.d(e);

        emit(ChatsPageErrorState("Error Occured: $e"));
      }
    });

    on<GetPendingRequestEvent>((event, emit) async {
      emit(ChatsPageLoadingState());

      FriendRequestService friendRequestService = FriendRequestService();
      var response =
          friendRequestService.getFriendRequests(event.currentUserId);

      response.listen((data) {
        var res = data.data;

        if (res != null) {
          if (!emit.isDone) {
            emit(AllPendingRequestSuccessState(res));
          }
        } else {
          if (!emit.isDone) {
            emit(ChatsPageErrorState(data.message!));
          }
        }
      });
    });

    on<GetAllCommunityEvent>(
      (event, emit) async {
        emit(const GetAllCommunityLoadingState());

        try {
          DatabaseReference _ref = db.ref("community");
          DatabaseEvent dataEvent = await _ref.once();
          Map<dynamic, dynamic>? data =
              dataEvent.snapshot.value as Map<dynamic, dynamic>?;
          List<CommunityData> communities = [];

          if (data != null) {
            data.forEach((key, value) {
              // key is communityOwnerId

              communities.add(CommunityData(
                  name: value["name"],
                  ownerId: value["ownerId"],
                  members: (value["members"] as Map?)?.map(
                        (key, val) => MapEntry(key as String, val),
                      ) ??
                      {},
                  createdAt: DateTime.parse(value["createdAt"].toString())));
            });

            //   (value as Map<dynamic, dynamic>).forEach((key, value) {

            // });

            emit(GetAllCommunitySuccessState(communities));
          } else {
            emit(const GetAllCommunityErrorState(
                "There is no community, try adding one"));
          }
        } catch (e) {
          logger.e(e);
          emit(GetAllCommunityErrorState("There an error occured: (Error) $e"));
        }
      },
    );

    on<AddCommunityEvent>(
      (event, emit) async {
        emit(const GetAllCommunityLoadingState());

        User? user = FirebaseAuth.instance.currentUser;

        try {
          DatabaseReference _ref =
              db.ref("community/community-id-${user!.uid}/members");
          // DatabaseReference _pushRef =

          var data = {
            "name": event.communityName,
            "ownerId": user.uid,
            // "members": 1,
            "createdAt": DateTime.now().toIso8601String()
          };

          _ref.set(data);

          emit(const AddCommunitySuccessState("Success"));
        } catch (e) {
          emit(AddCommunityErrorState("There an error occured: (Error) $e"));
        }
      },
    );
  }
}
