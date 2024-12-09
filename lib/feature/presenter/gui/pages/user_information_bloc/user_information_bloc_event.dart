part of 'user_information_bloc_bloc.dart';

abstract class UserInformationBlocEvent extends Equatable {
  const UserInformationBlocEvent();
}

class AddUpdateUserLocation extends UserInformationBlocEvent {
  final UserAddressParams params;
  const AddUpdateUserLocation(this.params);

  @override
  List<Object> get props => [params];
}

class GetUidEvent extends UserInformationBlocEvent {
  final UserUidParams params;
  const GetUidEvent(this.params);

  @override
  List<Object> get props => [params];
}

class LogoutEvent extends UserInformationBlocEvent {
  final NoParams noParams;

  const LogoutEvent(this.noParams);
  @override
  List<Object?> get props => [noParams];
}
