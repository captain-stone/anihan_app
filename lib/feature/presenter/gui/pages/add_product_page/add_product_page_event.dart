part of 'add_product_page_bloc.dart';

abstract class AddProductPageEvent extends Equatable {
  const AddProductPageEvent();

  @override
  List<Object> get props => [];
}

class AddProductEvent extends AddProductPageEvent {
  final ProductParams params;
  const AddProductEvent(this.params);
}
