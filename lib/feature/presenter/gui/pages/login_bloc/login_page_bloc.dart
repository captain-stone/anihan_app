import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/domain/entities/login_entity.dart';
import 'package:anihan_app/feature/domain/parameters/login_params.dart';
import 'package:anihan_app/feature/domain/usecases/login_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

@injectable
class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  final LoginUsecase _loginUsecase;

  LoginPageBloc(this._loginUsecase) : super(LoginPageInitial()) {
    on<GetLoginEvent>((event, emit) async {
      emit(LoginPageLoadingState());
      var result = await _loginUsecase(event.params);
      var status = result.status;
      var errorType = result.errorType;

      if (status == Status.success) {
        var data = result.data;

        if (data != null) {
          emit(LoginSuccessState(data: data));
        } else {
          emit(LoginErrorState(result.message!));
        }
      } else if (status == Status.initial) {
        emit(LoginPageInitial());
      } else {
        if (errorType == ErrorType.firebaseError) {
          emit(LoginFirebaseErrorState(result.message!));
        } else if (errorType == ErrorType.noInternet) {
          emit(LoginInternetErrorState(result.message!));
        } else {
          emit(LoginErrorState(result.message!));
        }
      }
    });
  }
}
