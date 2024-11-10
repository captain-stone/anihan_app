part of 'product_showcase_bloc.dart';

abstract class ProductShowcaseState extends Equatable {
  const ProductShowcaseState();

  @override
  List<Object> get props => [];
}

final class ProductShowcaseInitial extends ProductShowcaseState {}

final class ProductShowcaseLoadingState extends ProductShowcaseState {}

final class ProductShowcaseSuccessState extends ProductShowcaseState {}

final class ProductShowcaseErrorState extends ProductShowcaseState {}
