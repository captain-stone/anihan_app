part of 'user_information_bloc_bloc.dart';

abstract class UserInformationBlocEvent extends Equatable {
  const UserInformationBlocEvent();
}

class GetUidEvent extends UserInformationBlocEvent {
  final UserUidParams params;
  GetUidEvent(this.params);

  @override
  List<Object> get props => [params];
}
