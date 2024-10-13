part of 'add_product_page_bloc.dart';

abstract class AddProductPageState extends Equatable {
  const AddProductPageState();

  @override
  List<Object> get props => [];
}

class AddProductPageInitial extends AddProductPageState {}

class AddProductPageSuccessState extends AddProductPageState {
  final List<ProductEntity> entity;
  const AddProductPageSuccessState(this.entity);
}

class AddProductPageErrorState extends AddProductPageState {
  final String message;
  final ErrorType errorType;
  const AddProductPageErrorState(this.message, this.errorType);
}

class AddProductPageInternetErrorState extends AddProductPageState {
  final String message;
  const AddProductPageInternetErrorState(this.message);
}
