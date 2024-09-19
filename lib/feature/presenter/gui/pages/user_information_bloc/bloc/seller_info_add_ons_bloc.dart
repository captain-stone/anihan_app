import 'dart:async';

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/firebase_model.dart';
import 'package:anihan_app/feature/data/models/dto/seller_registrations_dto.dart';
import 'package:anihan_app/feature/domain/entities/registration_farmers_entity.dart';
import 'package:anihan_app/feature/presenter/gui/pages/seller_registration_bloc/seller_registration_bloc.dart';
import 'package:bloc/bloc.dart';
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
  DatabaseReference _sellerUpdateRef;

  final Logger logger = Logger();
  late StreamSubscription? _subscription;
  SellerInfoAddOnsBloc(this._refs, this._sellerUpdateRef)
      : super(SellerInfoAddOnsInitial()) {
    on<SellerStreanEvent>((event, emit) async {
      try {
        _subscription = _refs.onValue.listen((event) {
          if (event.snapshot.value == null) {
            if (!emit.isDone) {
              emit(SellerInfoAddOnsErrorState("No data saved"));
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
                  emit(SellerInfoAddOnsErrorState("No data saved"));
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
        logger.d(e);
        emit(SellerInfoAddOnsErrorState("Error Occured: $e"));
      }
    });
  }
}
