import 'package:anihan_app/feature/domain/entities/sign_up_entity.dart';
import 'package:anihan_app/feature/domain/parameters/sign_up_params.dart';
import 'package:anihan_app/feature/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../common/api_result.dart';

part 'register_page_event.dart';
part 'register_page_state.dart';

@injectable
class RegisterPageBloc extends Bloc<RegisterPageEvent, RegisterPageState> {
  final SignUpUsecase _signUpUsecase;

  RegisterPageBloc(this._signUpUsecase) : super(RegisterPageInitial()) {
    on<GetRegistrationEvent>((event, emit) async {
      emit(RegisterPageLoadingState());

      var result = await _signUpUsecase(event.params);

      var status = result.status;
      var errorType = result.errorType;

      if (status == Status.success) {
        var data = result.data;

        if (data != null) {
          emit(RegisteredSuccessState(data));
        } else {
          emit(RegisterErrorState(result.message!));
        }
      } else {
        if (errorType == ErrorType.noInternet) {
          emit(RegisterInternetErrorState(result.message!));
        } else if (errorType == ErrorType.firebaseError) {
          emit(RegisterFirebaseErrorState(result.message!));
        } else {
          emit(RegisterErrorState(result.message!));
        }
      }
    });
  }
}
