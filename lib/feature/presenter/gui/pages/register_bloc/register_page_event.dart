part of 'register_page_bloc.dart';

abstract class RegisterPageEvent extends Equatable {
  const RegisterPageEvent();
}

class GetRegistrationEvent extends RegisterPageEvent {
  final SignUpParams params;
  GetRegistrationEvent(this.params);
  @override
  List<Object> get props => [params];
}
