import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/domain/entities/registration_farmers_entity.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';
import 'package:anihan_app/feature/domain/usecases/registration_farmers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'seller_registration_event.dart';
part 'seller_registration_state.dart';

@injectable
class SellerRegistrationBloc
    extends Bloc<SellerRegistrationEvent, SellerRegistrationState> {
  final RegistrationFarmersUsecase _registrationFarmersUsecase;

  SellerRegistrationBloc(this._registrationFarmersUsecase)
      : super(SellerRegistrationInitial()) {
    on<SellerUidEvent>((event, emit) async {
      emit(SellerRegistrationLoadingState());

      var result = await _registrationFarmersUsecase(event.params);
      var status = result.status;

      if (status == Status.success) {
        var data = result.data;
        if (data != null) {
          emit(SellerRegistrationSuccessState(data));
        } else {
          emit(SellerErrorState(result.message!));
        }
      } else {
        var errorType = result.errorType;

        if (errorType == ErrorType.noInternet) {
          emit(SellerInternetErrorState(result.message!));
        } else {
          emit(SellerErrorState(result.message!));
        }
      }
    });
  }
}
