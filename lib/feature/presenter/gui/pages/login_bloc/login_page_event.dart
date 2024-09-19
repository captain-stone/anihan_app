part of 'login_page_bloc.dart';

abstract class LoginPageEvent extends Equatable {
  const LoginPageEvent();

  @override
  List<Object> get props => [];
}

class GetLoginEvent extends LoginPageEvent {
  final LoginParams? params;
  const GetLoginEvent({this.params});
}
