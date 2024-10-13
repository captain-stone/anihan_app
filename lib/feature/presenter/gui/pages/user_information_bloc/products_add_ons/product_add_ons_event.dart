part of 'product_add_ons_bloc.dart';

sealed class ProductAddOnsEvent extends Equatable {
  const ProductAddOnsEvent();

  @override
  List<Object> get props => [];
}

class GetSelfProductEvents extends ProductAddOnsEvent {
  @override
  List<Object> get props => [];
}
