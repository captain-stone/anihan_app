import 'package:anihan_app/feature/domain/entities/user_information_and_data_entity.dart';
import 'package:anihan_app/feature/domain/parameters/params.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';
import 'package:anihan_app/feature/domain/usecases/login_usecase.dart';
import 'package:anihan_app/feature/domain/usecases/user_information_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../../common/api_result.dart';

part 'user_information_bloc_event.dart';
part 'user_information_bloc_state.dart';

@injectable
class UserInformationBlocBloc
    extends Bloc<UserInformationBlocEvent, UserInformationBlocState> {
  final UserInformationUsecase _usecase;
  final LogoutUsecase _logoutUsecase;

  UserInformationBlocBloc(this._usecase, this._logoutUsecase)
      : super(UserInformationBlocInitial()) {
    on<GetUidEvent>((event, emit) async {
      emit(UserInformationLoadingState());

      var result = await _usecase(event.params);
      var status = result.status;

      if (status == Status.success) {
        var data = result.data;
        if (data != null) {
          emit(UserInformationSuccessState(data));
        } else {
          emit(UserInformationErrorState(result.message!));
        }
      } else {
        var errorType = result.errorType;

        if (errorType == ErrorType.noInternet) {
          emit(UserInformationInternetErrorState(result.message!));
        } else {
          emit(UserInformationErrorState(result.message!));
        }
      }
    });

    // on<AddUpdateUserLocation>((event, emit) async {
    //   emit(UserInformationLoadingState());
    //   var data = event.params;
    //   Logger logger = Logger();

    //   logger.d(data);
    // });

    on<LogoutEvent>((event, emit) async {
      emit(UserInformationLoadingState());

      var result = await _logoutUsecase(event.noParams);
      var status = result.status;

      if (status == Status.success) {
        var data = result.data;
        if (data == null) {
          emit(const LogoutSuccessState("Thank you! Come back again"));
        } else {
          emit(LogOutErrorState(result.message!));
        }
      } else {
        emit(LogOutErrorState(result.message!));
      }
    });
  }
}
