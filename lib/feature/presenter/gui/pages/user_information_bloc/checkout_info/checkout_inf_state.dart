part of 'checkout_inf_bloc.dart';

abstract class CheckoutInfState extends Equatable {
  const CheckoutInfState();
}

class CheckoutInfInitial extends CheckoutInfState {
  @override
  List<Object> get props => [];
}

class CheckoutInfLoadingState extends CheckoutInfState {
  const CheckoutInfLoadingState();
  @override
  List<Object> get props => [];
}

class CheckoutInfSuccessState extends CheckoutInfState {
  final Map<String, List<CheckoutProductDto>> data;
  const CheckoutInfSuccessState(this.data);
  @override
  List<Object> get props => [];
}

class CheckoutInfErrorState extends CheckoutInfState {
  final String message;
  const CheckoutInfErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class ApprovalSuccessState extends CheckoutInfState {
  final Map<String, dynamic> message;

  const ApprovalSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class ApprovalErrorState extends CheckoutInfState {
  final String message;

  const ApprovalErrorState(this.message);

  @override
  List<Object> get props => [message];
}
