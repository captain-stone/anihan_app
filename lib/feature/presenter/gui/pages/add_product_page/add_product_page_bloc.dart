import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_params.dart';
import 'package:anihan_app/feature/domain/usecases/product_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'add_product_page_event.dart';
part 'add_product_page_state.dart';

@injectable
class AddProductPageBloc
    extends Bloc<AddProductPageEvent, AddProductPageState> {
  final ProductUsecase _productUsecase;
  AddProductPageBloc(this._productUsecase) : super(AddProductPageInitial()) {
    on<AddProductEvent>((event, emit) async {
      emit(AddProductPageLoadingState());

      var result = await _productUsecase(event.params);

      var status = result.status;

      if (status == Status.success) {
        var data = result.data;
        if (data != null) {
          emit(AddProductPageSuccessState(data));
        } else {
          emit(AddProductPageErrorState(result.message!, ErrorType.nullError));
        }
      } else {
        var errorType = result.errorType;

        if (errorType == ErrorType.noInternet) {
          emit(AddProductPageInternetErrorState(result.message!));
        } else {
          emit(AddProductPageErrorState(result.message!, errorType!));
        }
      }
    });
  }
}
