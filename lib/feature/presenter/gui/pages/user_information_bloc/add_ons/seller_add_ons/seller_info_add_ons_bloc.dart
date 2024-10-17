// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:anihan_app/common/api_result.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

import 'package:logger/logger.dart';

part 'seller_info_add_ons_event.dart';
part 'seller_info_add_ons_state.dart';

@injectable
class SellerInfoAddOnsBloc
    extends Bloc<SellerInfoAddOnsEvent, SellerInfoAddOnsState> {
  final DatabaseReference _refs;
  final DatabaseReference _sellerUpdateRef;

  final Logger logger = Logger();
  late StreamSubscription? _subscription;
  SellerInfoAddOnsBloc(this._refs, this._sellerUpdateRef)
      : super(SellerInfoAddOnsInitial()) {
    on<SellerStreanEvent>((event, emit) async {
      try {
        _subscription = _refs.onValue.listen((event) {
          if (event.snapshot.value == null) {
            if (!emit.isDone) {
              emit(const SellerInfoAddOnsErrorState("No data saved"));
            }
            _subscription?.isPaused;
          } else {
            // logger.d(event.snapshot.value);
            var dataObject = (event.snapshot.value as Map?);

            var data = dataObject
                ?.map((key, value) => MapEntry(key.toString(), value));

            //data is storename, storeaddress, and isApproved
            if (data != null) {
              // logger.d(data["isApproved"]);

              if (!emit.isDone) {
                if (data["isApproved"] == Approval.approved.name) {
                  //we update the data to approved
                  _sellerUpdateRef.update({'farmers': Approval.approved.name});
                  data['farmers'] = Approval.approved.name;
                } else if (data["isApproved"] ==
                    Approval.pendingApproval.name) {
                  _sellerUpdateRef
                      .update({'farmers': Approval.pendingApproval.name});
                } else {
                  if (data.containsKey('farmers')) {
                    _sellerUpdateRef
                        .update({'farmers': Approval.notApproved.name});
                    data.remove('farmers');
                  }
                }
                emit(SellerInfoAddOnsSuccessState(data));
                _subscription?.isPaused;
              } else {
                if (!emit.isDone) {
                  emit(const SellerInfoAddOnsErrorState("No data saved"));
                }
                _subscription?.isPaused;
              }
            }
          }
        }, onDone: () {
          _subscription!.asFuture();
        }, onError: (error) {
          logger.e(error);
          emit(SellerInfoAddOnsErrorState("Error Occured: $error"));
        });
        await _subscription!.asFuture();
      } catch (e) {
        logger.e(e);
        emit(SellerInfoAddOnsErrorState("Error Occured: $e"));
      }
    });
  }
}
