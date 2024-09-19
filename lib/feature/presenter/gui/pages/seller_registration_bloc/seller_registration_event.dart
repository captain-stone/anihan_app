part of 'seller_registration_bloc.dart';

abstract class SellerRegistrationEvent extends Equatable {
  const SellerRegistrationEvent();
}

class SellerUidEvent extends SellerRegistrationEvent {
  final FarmersRegistrationParams params;
  SellerUidEvent(this.params);
  @override
  List<Object> get props => [params];
}
