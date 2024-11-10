part of 'product_showcase_bloc.dart';

abstract class ProductShowcaseEvent extends Equatable {
  const ProductShowcaseEvent();
}

class GetProductInformations extends ProductShowcaseEvent {
  @override
  List<Object> get props => [];
}

class GetStoreInformations extends ProductShowcaseEvent {
  final String? storeId;
  const GetStoreInformations({this.storeId});
  @override
  List<Object?> get props => [storeId];
}
