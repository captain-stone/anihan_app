part of 'user_information_bloc_bloc.dart';

abstract class UserInformationBlocState extends Equatable {
  const UserInformationBlocState();
}

class UserInformationBlocInitial extends UserInformationBlocState {
  @override
  List<Object> get props => [];
}

class UserInformationLoadingState extends UserInformationBlocState {
  @override
  List<Object> get props => [];
}

class UserInformationSuccessState extends UserInformationBlocState {
  final UserInformationEntity userInformationEntity;

  UserInformationSuccessState(this.userInformationEntity);
  @override
  List<Object> get props => [userInformationEntity];
}

class UserInformationErrorState extends UserInformationBlocState {
  final String message;

  UserInformationErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class UserInformationInternetErrorState extends UserInformationBlocState {
  final String message;
  UserInformationInternetErrorState(this.message);
  @override
  List<Object> get props => [message];
}
