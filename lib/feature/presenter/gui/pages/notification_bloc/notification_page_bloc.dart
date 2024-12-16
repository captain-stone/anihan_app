// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/common/enum_files.dart';
import 'package:anihan_app/feature/data/models/api/user_information_service_api.dart';
import 'package:anihan_app/feature/domain/entities/community_data.dart';
import 'package:anihan_app/feature/presenter/gui/pages/wish_list_page/wish_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'notification_page_event.dart';
part 'notification_page_state.dart';

@injectable
class NotificationPageBloc
    extends Bloc<NotificationPageEvent, NotificationPageState> {
  final FirebaseDatabase db = FirebaseDatabase.instance;

  final Logger logger = Logger();
  late StreamSubscription? _subscription;
  NotificationPageBloc() : super(NotificationPageInitial()) {
    on<GetFarmersNotificationsEvent>((event, emit) async {
      DatabaseReference _refs = db.ref("farmers/${event.uid}/");
      logger.d(event.uid);

      try {
        _subscription = _refs.onValue.listen((event) {
          if (event.snapshot.value == null) {
            if (!emit.isDone) {
              emit(const NotificationPageErrorState("No data saved"));
            }
            _subscription?.isPaused;
          } else {
            logger.d(event.snapshot.value);
            var dataObject = (event.snapshot.value as Map?);

            var data = dataObject
                ?.map((key, value) => MapEntry(key.toString(), value));

            //data is storename, storeaddress, and isApproved
            if (data != null) {
              logger.d(data["isApproved"]);

              // if (!emit.isDone) {
              //   if (data["isApproved"] == Approval.approved.name) {
              //     //we update the data to approved
              //     // _sellerUpdateRef.update({'farmers': Approval.approved.name});
              //     data['farmers'] = Approval.approved.name;
              //   } else if (data["isApproved"] ==
              //       Approval.pendingApproval.name) {
              //     // _sellerUpdateRef
              //     //     .update({'farmers': Approval.pendingApproval.name});
              //   } else {

              //   }

              emit(NotificationPageSuccessState(data));
              _subscription?.isPaused;
            } else {
              if (!emit.isDone) {
                emit(const NotificationPageErrorState("No data saved"));
              }
              _subscription?.isPaused;
            }
          }
        }, onDone: () {
          _subscription!.asFuture();
        }, onError: (error) {
          logger.e(error);
          emit(NotificationPageErrorState("Error Occured: $error"));
        });
        await _subscription!.asFuture();
      } catch (e) {
        logger.d(e);
        emit(NotificationPageErrorState("Error Occured: $e"));
      }
    });

    on<GetCommunityNotification>((event, emit) async {
      emit(const NotificationCommunitiesLoadingState());
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const NotificationCommunitiesErrorState("User not authenticated"));
        return;
      }

      DatabaseReference _ref = db.ref("community/community-id-${user.uid}");
      UserInformationServiceApi _serviceApi = UserInformationServiceApi();

      try {
        List<CommunityData> comminities = [];

        _subscription = _ref.onValue.listen((event) async {
          if (event.snapshot.value == null) {
            if (!emit.isDone) {
              emit(const NotificationPageErrorState(
                  "There's no update about our community"));
            }
            // return;
          }

          var object = event.snapshot.value as Map?;
          if (object != null) {
            comminities.clear(); // Prevent duplicate entries

            var membersMap = (object['members'] as Map?) ?? {};
            var memberDetails = await Future.wait(
              membersMap.entries.map((entry) async {
                var value = entry.value;
                // logger.d(value['status']);
                // logger.d(value['status'].runtimeType);
                // logger.d(JoinCommunity.requested.name);
                // logger.d(value['status'] == JoinCommunity.requested.name);
                // logger.d(value['status'] == JoinCommunity.requested);
                if (value['status'] == JoinCommunity.requested.name) {
                  var userInformation =
                      await _serviceApi.getUserInformationById(value['id']);
                  return CommunityData(
                    name: object['name'],
                    ownerId: object['ownerId'],
                    createdAt: DateTime.parse(object['createdAt']),
                    members: {
                      'userId': value['id'],
                      'usersName': userInformation.displayName,
                      'status': value['status'],
                    },
                  );
                }
                if (value['status'] == JoinCommunity.accepted.name) {
                  var userInformation =
                      await _serviceApi.getUserInformationById(value['id']);
                  return CommunityData(
                    name: object['name'],
                    ownerId: object['ownerId'],
                    createdAt: DateTime.parse(object['createdAt']),
                    members: {
                      'userId': value['id'],
                      'usersName': userInformation.displayName,
                      'status': value['status'],
                    },
                  );
                }
                return null;
              }).where((e) => e != null),
            );

            if (comminities.isNotEmpty) {
              comminities.addAll(memberDetails.cast<CommunityData>());
              if (!emit.isDone) {
                emit(NotificationCommunitiesSuccessState(comminities));
              }
            } else {
              if (!emit.isDone) {
                emit(const NotificationCommunitiesSuccessState([]));
              }
            }
          }
        }, onError: (error) {
          if (!emit.isDone) {
            emit(NotificationCommunitiesErrorState(
                "There's an error occurred: $error"));
          }
        }, onDone: () {
          _subscription!.asFuture();
        });

        await _subscription!.asFuture();
      } catch (e) {
        emit(
            NotificationCommunitiesErrorState("There's an error occurred: $e"));
      }
    });

    on<AcceptCommunityRequestEvent>((event, emit) async {
      emit(const AcceptDenyCommunitiesLoadingState());
      var data = event.data;

      User? user = FirebaseAuth.instance.currentUser;

      try {
        DatabaseReference _ref =
            db.ref('community/community-id-${user!.uid}/members');

        var updateStatus = {
          "status": JoinCommunity.accepted.name,
          "createdAt": DateTime.now().toIso8601String()
        };

        DataSnapshot snapshot = await _ref.get();
        if (snapshot.exists) {
          Map<dynamic, dynamic> members =
              snapshot.value as Map<dynamic, dynamic>;
          String? memberKey;

          members.forEach((key, value) {
            if (value['id'] == data['memberId']) {
              memberKey = key;
            }
          });

          if (memberKey != null) {
            DatabaseReference memberRef = _ref.child(memberKey!);

            // DatabaseReference _pushRef = memberRef.push();

            await memberRef.set(updateStatus).then((_) {
              emit(AcceptCommunitiesSuccessState({
                "status": Status.success.name,
              }));
            }).catchError((error) {
              emit(AcceptDenyCommunitiesErrorState(
                  "There's an error updating data. (Error) $error"));
            });
          }
        }
      } catch (e) {
        emit(AcceptDenyCommunitiesErrorState(
            "There's an error updating data. (Error) $e"));
      }

      //update the data on members.
    });
    on<DenyCommunityRequestEvent>((event, emit) async {
      emit(const AcceptDenyCommunitiesLoadingState());
      var data = event.data;

      User? user = FirebaseAuth.instance.currentUser;

      try {
        DatabaseReference _ref =
            db.ref('community/community-id-${user!.uid}/members');

        var updateStatus = {
          "status": JoinCommunity.deny.name,
          "createdAt": DateTime.now().toIso8601String()
        };

        DataSnapshot snapshot = await _ref.get();
        if (snapshot.exists) {
          Map<dynamic, dynamic> members =
              snapshot.value as Map<dynamic, dynamic>;
          String? memberKey;

          members.forEach((key, value) {
            if (value['id'] == data['memberId']) {
              memberKey = key;
            }
          });

          if (memberKey != null) {
            DatabaseReference memberRef = _ref.child(memberKey!);
            await memberRef.update(updateStatus).then((_) {
              emit(AcceptCommunitiesSuccessState({
                "status": Status.success.name,
              }));
            }).catchError((error) {
              emit(AcceptDenyCommunitiesErrorState(
                  "There's an error updating data. (Error) $error"));
            });
          }
        }
      } catch (e) {
        emit(AcceptDenyCommunitiesErrorState(
            "There's an error updating data. (Error) $e"));
      }
    });
  }
}
