part of 'register_page_bloc.dart';

abstract class RegisterPageState extends Equatable {
  const RegisterPageState();
}

class RegisterPageInitial extends RegisterPageState {
  @override
  List<Object> get props => [];
}

class RegisterPageLoadingState extends RegisterPageState {
  @override
  List<Object> get props => [];
}

class RegisteredSuccessState extends RegisterPageState {
  final SignUpEntity data;

  const RegisteredSuccessState(this.data);
  @override
  List<Object> get props => [data];
}

class RegisterInternetErrorState extends RegisterPageState {
  final String message;

  const RegisterInternetErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class RegisterErrorState extends RegisterPageState {
  final String message;
  const RegisterErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class RegisterFirebaseErrorState extends RegisterPageState {
  final String message;
  const RegisterFirebaseErrorState(this.message);
  @override
  List<Object> get props => [message];
}
