part of 'remove_checkout_cubit.dart';

sealed class RemoveCheckoutState extends Equatable {
  const RemoveCheckoutState();
}

class RemoveCheckoutInitial extends RemoveCheckoutState {
  @override
  List<Object> get props => [];
}

class RemoveCheckoutLoadingState extends RemoveCheckoutState {
  @override
  List<Object> get props => [];
}

class RemoveCheckoutSuccessState extends RemoveCheckoutState {
  final String message;
  const RemoveCheckoutSuccessState(this.message);
  @override
  List<Object> get props => [];
}

class RemoveCheckoutErrorState extends RemoveCheckoutState {
  final String message;
  const RemoveCheckoutErrorState(this.message);
  @override
  List<Object> get props => [];
}
//  class RemoveCheckoutErrorState extends RemoveCheckoutState {}
