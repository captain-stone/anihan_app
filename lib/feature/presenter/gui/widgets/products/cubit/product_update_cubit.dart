import 'package:anihan_app/feature/presenter/gui/widgets/products/products_add_ons_bloc/product_add_ons_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

part 'product_update_state.dart';

@injectable
class ProductUpdateCubit extends Cubit<ProductUpdateState> {
  ProductUpdateCubit() : super(ProductUpdateInitial());

  Future<void> updateMainProductQuantity(
      String productId, String productName, int quantity) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      DatabaseReference _ref = FirebaseDatabase.instance
          .ref('products/product-id${user!.uid}/$productId');

      _ref.update({"productQuantity": quantity});
      emit(ProductUpdateSuccessState());
    } on Exception catch (e) {
      emit(ProductUpdateErrorState(e.toString()));
    }
  }

  Future<void> updateVariantMainProductQuantity(
      String productId, int productIndex, int quantity) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      DatabaseReference _ref = FirebaseDatabase.instance
          .ref('products/product-id${user!.uid}/$productId');

      _ref
          .child('/variant-${user.uid}-id/$productIndex')
          .update({"variantQuantity": quantity.toString()});
      emit(ProductUpdateSuccessState());
    } on Exception catch (e) {
      emit(ProductUpdateErrorState(e.toString()));
    }
  }
}
