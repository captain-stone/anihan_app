part of 'add_to_cart_bloc.dart';

abstract class AddToCartState extends Equatable {
  const AddToCartState();
}

class AddToCartInitial extends AddToCartState {
  @override
  List<Object> get props => [];
}

class AddToCartLoadingState extends AddToCartState {
  @override
  List<Object> get props => [];
}

class AddToCartSuccessState extends AddToCartState {
  final AddToCartEntity dataModel;
  const AddToCartSuccessState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}

class AddToCartErrorState extends AddToCartState {
  final String message;
  const AddToCartErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class AllCartSuccessState extends AddToCartState {
  final List<AllCartEntity> dataModel;
  const AllCartSuccessState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}
