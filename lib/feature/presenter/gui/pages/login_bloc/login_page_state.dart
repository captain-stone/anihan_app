part of 'login_page_bloc.dart';

abstract class LoginPageState extends Equatable {
  const LoginPageState();
}

class LoginPageInitial extends LoginPageState {
  @override
  List<Object> get props => [];
}

class LoginPageLoadingState extends LoginPageState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginPageState {
  final LoginEntity? data;
  const LoginSuccessState({this.data});
  @override
  List<Object?> get props => [data];
}

class LoginInternetErrorState extends LoginPageState {
  final String message;

  const LoginInternetErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class LoginFirebaseErrorState extends LoginPageState {
  final String message;
  const LoginFirebaseErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class LoginErrorState extends LoginPageState {
  final String message;
  const LoginErrorState(this.message);
  @override
  List<Object> get props => [message];
}
