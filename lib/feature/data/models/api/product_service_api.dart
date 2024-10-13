// ignore_for_file: unused_catch_clause, no_leading_underscores_for_local_identifiers

import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

mixin ProductServiceApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;

  Future<List<ProductEntity>> sellersInformation(ProductParams params) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    Map<String, dynamic> productData = {};
    final logger = Logger();

    try {
      if (user != null) {
        DatabaseReference _refs = db.ref("products/product-id${user.uid}");
        DatabaseReference newProductRef = _refs.push();
        // DatabaseReference _refsVariations =
        //     db.ref("products/product-id${user.uid}");

        productData = {
          "name": params.productName,
          user.uid: true,
          "storeId-${user.uid}-id": true,
          "label": params.productLabel,
          "price": params.productPrice,
          "itemDescriptions": params.itemDescriptions,
          "variant-${user.uid}-id": params.productVariant,
        };

        await newProductRef.set(productData);
        // _refsVariations.set(variants);
        DataSnapshot dataSnapshot =
            await _refs.once().then((event) => event.snapshot);

        // DataSnapshot dataSnapshotVariants =
        //     await _refsVariations.once().then((event) => event.snapshot);

        Map<dynamic, dynamic>? productDataList = dataSnapshot.value as Map?;
        // Map<dynamic, dynamic>? productDataListVariants =
        //     dataSnapshotVariants.value as Map?;

        if (productDataList != null) {
          // Access each product
          var productEntities = productDataList.entries
              .map((entry) {
                // Check if the entry value is a Map
                if (entry.value is Map<dynamic, dynamic>) {
                  Map<dynamic, dynamic> productInfo =
                      entry.value as Map<dynamic, dynamic>;

                  String productName =
                      productInfo['name'] as String? ?? 'Unknown';
                  String productLabel =
                      productInfo['label'] as String? ?? 'No Label';
                  double productPrice =
                      (productInfo['price'] as num?)?.toDouble() ?? 0.0;
                  String itemDescriptions =
                      productInfo['itemDescriptions'] as String? ??
                          'No Description';

                  // Safely handle the variants
                  // List<Map<String, dynamic>> productVariants =
                  //     productInfo['variant-${user.uid}-id'] is List
                  //         ? (productInfo['variant-${user.uid}-id'] as List)
                  //             .map((variant) => variant as Map<String, dynamic>)
                  //             .toList()
                  //         : [];

                  List<Map<String, dynamic>> productVariants =
                      (productInfo['variant-${user.uid}-id'] as List<dynamic>?)
                              ?.map((variant) => {
                                    'productName': variant['productName'],
                                    'productPrice': variant['productPrice']
                                  })
                              .toList() ??
                          []; // Fallback to an empty list
                  return ProductEntity(
                    productName,
                    productLabel,
                    productPrice,
                    itemDescriptions,
                    productVariant: productVariants,
                  );
                } else {
                  // Handle unexpected types; return null
                  logger.d("Expected a Map but got: ${entry.value}");
                  return null; // or handle it as per your logic
                }
              })
              .where((entity) => entity != null)
              .cast<ProductEntity>()
              .toList(); // Filter out nulls and cast to List<ProductEntity>

          return productEntities;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } on Exception catch (e) {
      rethrow;
    }
  }
}
