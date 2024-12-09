// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';

import 'package:anihan_app/common/api_result.dart';

import 'package:anihan_app/feature/data/models/api/name_store_name_api.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

part 'check_friends_event.dart';
part 'check_friends_state.dart';

class CheckFriendsBloc extends Bloc<CheckFriendsEvent, CheckFriendsState> {
  final Logger logger = Logger();
  final FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late StreamSubscription? _subscription;

  CheckFriendsBloc() : super(CheckFriendsInitial()) {
    on<GetFriendListCountEvent>((event, emit) async {
      emit(CheckFriendsLoadingState());

      DatabaseReference _friendRef = db.ref("friend_requests"),
          _userInformationRef = db.ref("users");
      User? _user = auth.currentUser;

      try {
        _subscription = _friendRef.onValue.listen((event) async {
          List<Map<String, dynamic>> friendRequest = [],
              friendRequestUserInformation = [];
          if (event.snapshot.value != null) {
            (event.snapshot.value as Map<dynamic, dynamic>)
                .forEach((key, value) {
              value.forEach((innerKey, innerValue) {
                if (innerValue['status'] == "pending" && key == _user!.uid) {
                  var entry = {
                    //list of friends
                    'friendRequestID': innerValue['fromUser'],
                    'timestamp': innerValue['timestamp'],
                    'status': innerValue['status'],
                  };

                  friendRequest.add(entry);
                }
              });
            });

            if (friendRequest.isNotEmpty) {
              for (var request in friendRequest) {
                //usersInformations
                String friendRequestId = request['friendRequestID'];
                DataSnapshot userSnapShot =
                    await _userInformationRef.child(friendRequestId).get();

                if (userSnapShot.exists) {
                  Map<String, dynamic> userInfo =
                      Map<String, dynamic>.from(userSnapShot.value as Map);

                  friendRequestUserInformation.add({
                    'requestedId': request['friendRequestID'],
                    'status': request['status'],
                    'timestamp': request['timestamp'],
                    'userInfo': userInfo,
                  });
                }
              }
            }

            if (!emit.isDone) {
              emit(CheckFriendsSuccessState(friendRequestUserInformation));
            }
          } else if (!emit.isDone) {
            emit(const CheckFriendsErrorState("No Friend requests found"));
          }
        }, onDone: () {
          _subscription!.asFuture();
        }, onError: (error) {
          emit(CheckFriendsErrorState("Error Occuere: $error"));
        });

        await _subscription!.asFuture();
      } catch (e) {
        emit(CheckFriendsErrorState("Error loading data (Error): $e"));
      }
    });

    on<UpdateFriendRequestEvent>((event, emit) async {
      emit(CheckFriendsLoadingState());
      //FriendRequestService friendRequestService = FriendRequestService();

      var action = event.action;
      var userRequestId = event.userId;

      DatabaseReference _friendRef = db.ref("friend_requests"),
          _userInformationRef = db.ref("users");
      User? _user = auth.currentUser;

      try {
        // var data = await friendRequestService.respondToFriendRequest(_user!.uid, userRequestId, true);
        DataSnapshot friendDataSnapShot =
            await _friendRef.child(_user!.uid).get();
        DataSnapshot userRequestSnapshot =
            await _friendRef.child(userRequestId).get();

        logger.d(userRequestSnapshot.exists);
        int newTimestamp = DateTime.now().millisecondsSinceEpoch;

        if (friendDataSnapShot.exists) {
          // logger.d(friendDataSnapShot.value);

          Map<String, dynamic> data =
              Map<String, dynamic>.from(friendDataSnapShot.value as Map);
          // logger.d(data);
          String? keyToUpdate;
          data.forEach((key, value) {
            if (value["fromUser"] == userRequestId) {
              keyToUpdate = key;
            }

            // if(value["to"])
          });

          if (keyToUpdate != null) {
            // Update the status and timestamp for the specific entry
            // await _friendRef.child(keyToUpdate!)
            //     .update({"status": action, "timestamp": newTimestamp});

            await _friendRef
                .child("${_user.uid}/$keyToUpdate")
                .update({"status": action, "timestamp": newTimestamp});

            // logger.d("Data updated for $keyToUpdate");
          } else {
            logger.d("fromUser not found");
          }
        }

        if (userRequestSnapshot.exists) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(userRequestSnapshot.value as Map);
          logger.d(data);
          String? keyToUpdate;

          data.forEach((key, value) async {
            if (value["fromUser"] == _user.uid) {
              keyToUpdate = key;
            }

            if (keyToUpdate != null) {
              await _friendRef
                  .child("$userRequestId/$keyToUpdate")
                  .update({"status": action, "timestamp": newTimestamp});
            }
          });
        }

        DataSnapshot finalData = await _friendRef.child(_user.uid).get();

        if (finalData.exists) {
          logger.d(finalData);
          emit(const AcceptFriendRequestSuccessState("Success"));
        } else {
          emit(const AcceptFriendRequestErrorState("Invalid"));
        }
      } catch (e) {
        emit(AcceptFriendRequestErrorState("Error loading data (Error): $e"));
      }
    });

    on<GetUserNameAndStoreNameEvent>((event, emit) async {
      emit(const GetUserAndStoreNameLoadingState());
      var id = event.storeId;
      NameStoreNameApi nameStoreNameApi = NameStoreNameApi();

      var response = await nameStoreNameApi.getNameAndStoreName(id);
      var status = response.status;

      if (status != Status.error) {
        var data = response.data;

        if (data != null) {
          emit(GetUserAndStoreNameSuccessState(data));
        } else {
          emit(GetUserAndStoreNameErrorState(response.message!));
        }
      } else {
        emit(GetUserAndStoreNameErrorState(response.message!));
      }
    });
  }
}
