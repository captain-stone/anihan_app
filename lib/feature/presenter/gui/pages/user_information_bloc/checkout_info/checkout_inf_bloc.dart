// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/checkout_api.dart';
import 'package:anihan_app/feature/data/models/dto/checkout_product_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'checkout_inf_event.dart';
part 'checkout_inf_state.dart';

@injectable
class CheckoutInfBloc extends Bloc<CheckoutInfEvent, CheckoutInfState> {
  final CheckoutClassApi _checkoutClassApi = CheckoutClassApi();
  final logger = Logger();
  late StreamSubscription? _subscription;
  CheckoutInfBloc() : super(CheckoutInfInitial()) {
    on<GetAllCheckoutProductEvent>((event, emit) async {
      emit(const CheckoutInfLoadingState());
      User? user = FirebaseAuth.instance.currentUser;
      try {
        //check the storeeeeeee

        List<CheckoutProductDto> dataList = [];
        List<CheckoutProductDto> dataListBuyer = [];
        DatabaseReference _ref = FirebaseDatabase.instance.ref("checkout");
        _subscription = _ref.onValue.listen((event) {
          if (event.snapshot.value != null) {
            var data = event.snapshot.value;
            (data as Map<dynamic, dynamic>).forEach((key, value) async {
              // logger.f(value);
              try {
                if ("storeId-${user?.uid ?? "None"}-id" == value['storeId']) {
                  var data1 = CheckoutProductDto.fromMap(
                      Map<String, dynamic>.from(value));
                  dataList.add(data1);
                }
                if ((user?.uid ?? "None") == value['buyer']) {
                  var data2 = CheckoutProductDto.fromMap(
                      Map<String, dynamic>.from(value));
                  dataListBuyer.add(data2);
                }
              } catch (e) {
                logger.e("Error parsing data for key $key: $e");
                if (!emit.isDone) {
                  emit(CheckoutInfErrorState(
                      "Error parsing data for key $key: $e"));
                }
              }
            });
            if (!emit.isDone) {
              emit(CheckoutInfSuccessState(
                  {"seller": dataList, "buyer": dataListBuyer}));
            }
          } else {
            if (!emit.isDone) {
              emit(const CheckoutInfErrorState("There is no checkouts"));
            }
          }
        }, onDone: () {
          _subscription!.asFuture();
        }, onError: (error) {
          logger.e(error);
          if (!emit.isDone) {
            emit(CheckoutInfErrorState(error.toString()));
          }
        });
        await _subscription!.asFuture();
      } catch (e) {
        emit(CheckoutInfErrorState(e.toString()));
      }
    });

    on<UpdatedApprovedCheckoutEvent>(
      (event, emit) async {
        emit(const CheckoutInfLoadingState());

        var result = await _checkoutClassApi.updateApproval(
            id: event.id, approval: event.approval);

        Status status = result.status;

        if (status != Status.error) {
          var data = result.data;

          if (data != null) {
            emit(ApprovalSuccessState(data));
          } else {
            emit(ApprovalErrorState(result.message!));
          }
        } else {
          emit(ApprovalErrorState(result.message!));
        }
      },
    );
  }
}
