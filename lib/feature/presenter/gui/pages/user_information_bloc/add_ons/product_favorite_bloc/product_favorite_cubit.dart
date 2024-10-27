// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/add_ons/products_add_ons_bloc/product_add_ons_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'product_favorite_state.dart';

class ProductFavoriteCubit extends Cubit<ProductFavoriteState> {
  ProductFavoriteCubit() : super(ProductFavoriteInitial());

  Future<void> addToFavorite(String productKey) async {
    // emit()
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseDatabase db = FirebaseDatabase.instance;

    User? user = auth.currentUser;

    try {
      if (user != null) {
        DatabaseReference _refs = db.ref("wishlist/${user.uid}");

        var favorite = {
          productKey: true,
        };
        _refs.update(favorite);

        DataSnapshot dataSnapshot =
            await _refs.once().then((event) => event.snapshot);

        if (dataSnapshot.exists) {
          var successMessage = {
            "message": "Product added to favorite",
            "favorite": productKey,
          };
          emit(ProductFavoriteSuccessState(successMessage));
        } else {
          emit(const ProductFavoriteErrorState(
              "Unsuccessfull adding to favorite"));
        }
      }
    } catch (e) {
      emit(ProductFavoriteErrorState("Error: $e"));
    }
  }
}
