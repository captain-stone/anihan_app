// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../data/models/api/firebase_model.dart';

part 'chats_page_event.dart';
part 'chats_page_state.dart';

@injectable
class ChatsPageBloc extends Bloc<ChatsPageEvent, ChatsPageState> {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  final Logger logger = Logger();
  late StreamSubscription? _subscription;

  ChatsPageBloc() : super(ChatsPageInitial()) {
    on<ChatsPageEvent>((event, emit) async {
      DatabaseReference _refs = db.ref("users/");

      try {
        _subscription = _refs.onValue.listen((event) {
          if (event.snapshot.value == null) {
            if (!emit.isDone) {
              emit(const ChatsPageErrorState("No data saved"));
            }
            _subscription?.isPaused;
          } else {
            // logger.d(event.snapshot.value);

            var data = (event.snapshot.value as Map<dynamic, dynamic>)
                .entries
                .map((entry) => FirebaseDataModel(
                    key: entry.key,
                    value: Map<String, dynamic>.from(entry.value)))
                .toList();

            if (!emit.isDone) {
              emit(ChatsPageSuccessState(data));
              _subscription?.isPaused;
            }

            //data is storename, storeaddress, and isApproved
          }
        }, onDone: () {
          _subscription!.asFuture();
        }, onError: (error) {
          logger.e(error);
          emit(ChatsPageErrorState("Error Occured: $error"));
        });
        await _subscription!.asFuture();
      } catch (e) {
        logger.d(e);
        emit(ChatsPageErrorState("Error Occured: $e"));
      }
    });

    on<AddingFriendEvent>((event, emit) async {
      DatabaseReference _refs = db.ref("users/");

      try {
        var userData = {
          "friends": {event.uid: true}
        };

        var addedFriendUpdateData = {
          "friends": {event.userUid: true}
        };

        //userUpdate
        _refs.child(event.userUid).update(userData);
        _refs.child(event.uid).update(addedFriendUpdateData);
        // emit(Cha)
      } catch (e) {
        // logger.d(e);
        emit(ChatsPageErrorState("Error Occured: $e"));
      }
    });

    on<SearchFriendEvent>((event, emit) async {
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
                  logger.e("Found user: $fullName with ID: $key");
                }
              }
            });

            if (matchedUsers.isEmpty) {
              logger.f("No user found matching: $query");

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
  }
}
