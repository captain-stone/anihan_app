part of 'checkout_inf_bloc.dart';

abstract class CheckoutInfEvent extends Equatable {
  const CheckoutInfEvent();
}

class GetAllCheckoutProductEvent extends CheckoutInfEvent {
  const GetAllCheckoutProductEvent();

  @override
  List<Object> get props => [];
}

class UpdatedApprovedCheckoutEvent extends CheckoutInfEvent {
  final String id;
  final String approval;

  const UpdatedApprovedCheckoutEvent(
      {required this.id, required this.approval});

  @override
  List<Object> get props => [id, approval];
}
