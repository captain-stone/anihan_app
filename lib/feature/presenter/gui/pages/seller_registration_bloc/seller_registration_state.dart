part of 'seller_registration_bloc.dart';

abstract class SellerRegistrationState extends Equatable {
  const SellerRegistrationState();
}

class SellerRegistrationInitial extends SellerRegistrationState {
  @override
  List<Object> get props => [];
}

class SellerRegistrationLoadingState extends SellerRegistrationState {
  @override
  List<Object> get props => [];
}

class SellerRegistrationSuccessState extends SellerRegistrationState {
  final RegistrationFarmersEntity registrationFarmersEntity;

  const SellerRegistrationSuccessState(this.registrationFarmersEntity);
  @override
  List<Object> get props => [registrationFarmersEntity];
}

class SellerPasswordErrorState extends SellerRegistrationState {
  final String message;

  const SellerPasswordErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class SellerErrorState extends SellerRegistrationState {
  final String message;
  const SellerErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class SellerInternetErrorState extends SellerRegistrationState {
  final String message;
  const SellerInternetErrorState(this.message);

  @override
  List<Object> get props => [message];
}
