import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_showcase_event.dart';
part 'product_showcase_state.dart';

class ProductShowcaseBloc
    extends Bloc<ProductShowcaseEvent, ProductShowcaseState> {
  ProductShowcaseBloc() : super(ProductShowcaseInitial()) {
    // on<ProductShowcaseEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<GetStoreInformations>(
      (event, emit) {
        var eventValue = event.storeId;
      },
    );
  }
}
