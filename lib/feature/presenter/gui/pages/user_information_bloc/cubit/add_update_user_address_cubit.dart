import 'dart:async';

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/user_information_service_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'add_update_user_address_state.dart';

@injectable
class AddUpdateUserAddressCubit extends Cubit<AddUpdateUserAddressState> {
  final logger = Logger();
  late final StreamSubscription _subscription;
  AddUpdateUserAddressCubit() : super(AddUpdateUserAddressInitial());

  Future<void> addUpdateAddress(
      String uid, String address, String selectedAddress) async {
    final UserInformationServiceApi _serviceApi = UserInformationServiceApi();
    emit(AddUpdateUserAddressLaodingState());

    var data =
        await _serviceApi.updateUserAddress(uid, address, selectedAddress);
    logger.d(data);

    if (data.isNotEmpty) {
      emit(AddUpdateUserAddressSuccessState(data));
    } else {
      emit(AddUpdateUserAddressErrorState());
    }
  }

  Future<void> updateSelectedAddress(String uid, String selectedAddress) async {
    final UserInformationServiceApi _serviceApi = UserInformationServiceApi();
    emit(AddUpdateUserAddressLaodingState());

    var data = await _serviceApi.updateSelectedAddress(uid, selectedAddress);
    logger.d(data);

    if (data.isNotEmpty) {
      emit(AddUpdateUserAddressSuccessState(data));
    } else {
      emit(AddUpdateUserAddressErrorState());
    }
  }

  Future<void> getAllTheSavedAddress(String uid) async {
    final UserInformationServiceApi _serviceApi = UserInformationServiceApi();
    emit(AddUpdateUserAddressLaodingState());

    var data = await _serviceApi.getAllSavedAddressApi(uid);

    if (data.isNotEmpty) {
      emit(AllSaveAddressSuccessState(data));
    } else {
      emit(AddUpdateUserAddressErrorState());
    }
    logger.d(data);
  }

  Future<void> getAllTheSavedAddressAndSelectedData(String uid) async {
    final UserInformationServiceApi _serviceApi = UserInformationServiceApi();
    emit(AddUpdateUserAddressLaodingState());

    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseDatabase db = FirebaseDatabase.instance;

    // try {
    //   DatabaseReference _refs = db.ref("users/$uid/saveAddress");
    //   _subscription = _refs.onValue.listen((event) {
    //     if(event.snapshot.value == null){
    //       if(!emit.isDone)
    //     }
    //   });
    // } catch (e) {}

    var data = await _serviceApi.getAllSavedAndSelectedAddressApi(uid);

    if (data.isNotEmpty) {
      emit(AllSaveAndSelectedAddressSuccessState(data));
    } else {
      emit(AddUpdateUserAddressErrorState());
    }
    logger.d(data);
  }
}
