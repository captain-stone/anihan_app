// ignore_for_file: unused_catch_clause, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:typed_data';

import 'package:anihan_app/feature/data/models/dto/product_dto.dart';
import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

mixin ProductServiceApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;

  Future<List<ProductEntity>> sellersInformation(ProductParams params) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    Map<String, dynamic> productData = {};
    late final ProductDataDto productDataDto;
    late final ProductVariantDto productVariantDto;
    List<Map<String, dynamic>> productVariantDtoList = [];
    final logger = Logger();

    try {
      if (user != null) {
        DatabaseReference _refs = db.ref("products/product-id${user.uid}");
        DatabaseReference newProductRef = _refs.push();
        // DatabaseReference _refsVariations =
        //     db.ref("products/product-id${user.uid}");

        List<String?> imageUrl = [];

        List<Map<String, dynamic>?>? variantData = [];

        int count = 0;
        if (params.imageDataList.isNotEmpty) {
          for (var image in params.imageDataList) {
            String? imageData = await _uploadImageToStorage(
                image,
                "jpg",
                "products/images/product-id${user.uid}/${params.productName}",
                params.productName,
                count);

            imageUrl.add(imageData);
            count++;
          }
        }

        var variantEntityList = params.productVariant;
        if (variantEntityList != null) {
          int countNum = 0;

          for (var data in variantEntityList) {
            String? variantImage = await _uploadImageToStorage(
                data!.imageData!,
                'jpg',
                "products/product-id${user.uid}/variant-images/",
                data.varianName!,
                countNum);

            productVariantDtoList.add(ProductVariantDto(
              variantImages: variantImage,
              variantName: data.varianName,
              variantPrice: data.variantPrice,
            ).toJson());

            countNum++;
          }
        }

        final userId = user.uid;

        productDataDto = ProductDataDto(
            imageList: imageUrl,
            productName: params.productName,
            productLabel: params.productLabel,
            productItemDescriptions: params.itemDescriptions,
            // productVariantDtoList: productVariantDtoList,
            productPrice: params.productPrice);

        productData = ProductDataDto.customToJson(
            productDataDto, productVariantDtoList, userId);

        logger.d(productData);

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
                String productIdKey = entry.key;
                // Check if the entry value is a Map
                if (entry.value is Map<dynamic, dynamic>) {
                  Map<dynamic, dynamic> productInfo =
                      entry.value as Map<dynamic, dynamic>;
                  List<String> productImages =
                      (productInfo['imageUrls'] as List<dynamic>?)
                              ?.map((imageUrl) => imageUrl as String)
                              .toList() ??
                          [];

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

                  List<ProductVariantEntity> productVariants =
                      (productInfo['variant-${user.uid}-id'] as List<dynamic>?)
                              ?.map((variant) => ProductVariantEntity(
                                  images: variant['variantImages'],
                                  varianName: variant['variantName'],
                                  variantPrice: variant['variantPrice']))
                              .toList() ??
                          []; // Fallback to an empty list
                  return ProductEntity(
                    productImages,
                    productName,
                    productLabel,
                    productPrice,
                    itemDescriptions,
                    productVariant: productVariants,
                    productKey: productIdKey,
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

  Future<String?> _uploadImageToStorage(Uint8List data, String extension,
      String refs, String fileName, int count) async {
    final logger = Logger();

    try {
      String _fileName = '${fileName.replaceAll(' ', '')}$count.$extension';
      // Reference storageRef =
      //     FirebaseStorage.instance.ref(refs).child('/$_fileName');
      // UploadTask uploadTask = storageRef.putData(data);

      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref(refs)
          .child('/$_fileName')
          .putData(data);

      // TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      logger.e('Failed to upload image: $e');
      return null;
    }
  }
}
