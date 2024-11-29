// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/feature/presenter/gui/widgets/products/products_add_ons_bloc/product_add_ons_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

part 'product_favorite_state.dart';

class ProductFavoriteCubit extends Cubit<ProductFavoriteState> {
  final logger = Logger();
  ProductFavoriteCubit() : super(ProductFavoriteInitial());

  Future<void> addToFavorite(String productKey, bool isFavorite) async {
    // emit()
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseDatabase db = FirebaseDatabase.instance;

    User? user = auth.currentUser;

    try {
      if (user != null) {
        DatabaseReference _refs = db.ref("wishlist/${user.uid}");

        var favorite = {
          productKey: isFavorite,
        };
        _refs.update(favorite);

        var successMessage = {
          "message": "Product added to favorite",
          "favorite": productKey,
        };
        emit(ProductFavoriteSuccessState(successMessage));
      }
    } catch (e) {
      emit(ProductFavoriteErrorState("Error: $e"));
    }
  }

  Future<void> getAllFavorite(String productId) async {
    emit(ProductFavoriteLoadingState());
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseDatabase db = FirebaseDatabase.instance;

    User? user = auth.currentUser;

    try {
      if (user != null) {
        DatabaseReference _refs = db.ref("wishlist/${user.uid}");

        DataSnapshot dataSnapshot =
            await _refs.once().then((event) => event.snapshot);

        if (dataSnapshot.exists) {
          var data = dataSnapshot.value;

          if (data is Map) {
            List<String> filteredKeys = data.entries
                .where((entry) => entry.value == true)
                .map((entry) => entry.key.toString())
                .toList();

            if (filteredKeys.isNotEmpty) {
              emit(ProducFavoriteDataState(filteredKeys));
            } else {
              emit(const ProductFavoriteErrorState(
                  "No favorite products found"));
            }
          } else {
            emit(const ProductFavoriteErrorState(
                "Invalid data format in wishlist"));
          }
        } else {
          emit(const ProductFavoriteErrorState("Wishlist does not exist"));
        }
      }
    } catch (e) {
      emit(ProductFavoriteErrorState("Error: $e"));
    }
  }
}
