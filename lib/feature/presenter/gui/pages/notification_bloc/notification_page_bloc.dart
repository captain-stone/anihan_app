// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

part 'notification_page_event.dart';
part 'notification_page_state.dart';

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
  }
}
