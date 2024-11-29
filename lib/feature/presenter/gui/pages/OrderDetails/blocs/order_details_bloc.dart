import 'package:flutter_bloc/flutter_bloc.dart';

enum OrderDetailsEvent { expand, collapse }

class OrderDetailsState {
  final bool isExpanded;
  const OrderDetailsState({required this.isExpanded});
}

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  OrderDetailsBloc() : super(const OrderDetailsState(isExpanded: false)) {
    on<OrderDetailsEvent>((event, emit) {
      if (event == OrderDetailsEvent.expand) {
        emit(const OrderDetailsState(isExpanded: true));
      } else if (event == OrderDetailsEvent.collapse) {
        emit(const OrderDetailsState(isExpanded: false));
      }
    });
  }
}
