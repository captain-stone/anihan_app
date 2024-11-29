// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_add_cart_params.dart';
import 'package:anihan_app/feature/services/date_services.dart';
import 'package:anihan_app/feature/services/generate_hash_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

mixin CheckoutApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final logger = Logger();

  Future<AddToCartEntity> checkout(
      List<ProductAddCartParams> params, String? storeId) async {
    User? user = auth.currentUser;
    final DateServices date = DateServices();
    String checkoutId = "";

    try {
      if (user != null) {
        int dateInMillis = date.dateNowMillis();
        checkoutId = generate16CharHash("$storeId$dateInMillis");

        DatabaseReference _refs =
            db.ref("checkout/${user.uid}/${storeId ?? "none"}/$checkoutId");
        double totalPrice = calculateTotal(params);

        _refs.set({"total": totalPrice.toDouble(), "created_at": dateInMillis});

        for (var param in params) {
          DatabaseReference _savingCartRef = _refs.push();
          logger.d(checkoutId);

          var data = {
            "name": param.name,
            "image": param.image,
            "price": param.price,
            "quantity": param.quantity,
          };
          await _savingCartRef.set(data);
        }

        // Fetch and return saved data
        DataSnapshot dataSnapshot =
            await _refs.once().then((event) => event.snapshot);

        Map<dynamic, dynamic>? cartDataList = dataSnapshot.value as Map?;
        logger.d(cartDataList);

        if (cartDataList != null) {
          // String cartIdFromFirebase = "None";
          var productsEntity = cartDataList.entries
              .map((entry) {
                if (entry.value.runtimeType == int) {
                  return null;
                }

                final map = entry.value as Map<dynamic, dynamic>;
                return AddToCartProductEntity(map["name"],
                    double.tryParse(map["price"].toString())!, map["quantity"]);
              })
              .whereType<AddToCartProductEntity>()
              .toList();

          return AddToCartEntity(
            storeId: storeId ?? "none",
            createAt: dateInMillis,
            cartId: checkoutId,
            totalPrice: totalPrice,
            productEntity: productsEntity,
          );
        } else {
          // return [];
          throw Exception("No saved data");
        }
      } else {
        // return [];
        throw Exception("No User found. Please login first");
      }
    } catch (e) {
      rethrow;
    }
  }

  double calculateTotal(List<ProductAddCartParams> dataParams) {
    return dataParams.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  Future<bool> saveCheckoutData({
    required List<AddToCartEntity> productEntity,
    required double total,
    required String deliveryDate,
  }) async {
    try {
      DatabaseReference _refs = db.ref("checkout");

      // Structure data for saving

      // var dateEntity =
      Map<String, dynamic> checkoutData = {
        'total': total,
        'deliveryDate': deliveryDate,
        'products': productEntity.map((e) => e.toJson()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Save data to Firebase
      await _refs.push().set(checkoutData);

      return true; // Indicate success
    } catch (e) {
      print("Error saving checkout data: $e");
      return false;
    }
  }
}
