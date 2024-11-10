part of 'seller_info_add_ons_bloc.dart';

abstract class SellerInfoAddOnsState extends Equatable {
  const SellerInfoAddOnsState();
}

class SellerInfoAddOnsInitial extends SellerInfoAddOnsState {
  @override
  List<Object> get props => [];
}

class SellerInfoAddOnsLoadingState extends SellerInfoAddOnsState {
  @override
  List<Object> get props => [];
}

class SellerInfoAddOnsSuccessState extends SellerInfoAddOnsState {
  final Map<String, dynamic> dataModel;
  const SellerInfoAddOnsSuccessState(this.dataModel);
  @override
  List<Object> get props => [dataModel];
}

class SellerInfoAddOnsErrorState extends SellerInfoAddOnsState {
  final String message;

  const SellerInfoAddOnsErrorState(this.message);
  @override
  List<Object> get props => [message];
}
