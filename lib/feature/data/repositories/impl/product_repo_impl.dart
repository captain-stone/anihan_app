import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/add_cart_api.dart';

import 'package:anihan_app/feature/data/models/api/product_service_api.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/product_repository.dart';
import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_add_cart_params.dart';
import 'package:anihan_app/feature/domain/parameters/product_params.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/debugger/logger_debugger.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@Injectable(as: ProductRepository)
class ProductRepoImpl extends ProductRepository
    with ProductServiceApi, CartServiceApi, LoggerEvent {
  final InternetConnectionChecker internetConnectionChecker;

  ProductRepoImpl(@Named('global') this.internetConnectionChecker);
  @override
  Future<ApiResult<List<ProductEntity>>> getProducts(
      ProductParams params) async {
    if (!(await internetConnectionChecker.hasConnection)) {
      return const ApiResult.noInternetConenction();
    } else {
      try {
        var returnedData = await sellersInformation(params);

        if (returnedData.isNotEmpty) {
          return ApiResult.success(returnedData);
        } else {
          return const ApiResult.error("Error saving data",
              errorType: ErrorType.nullError);
        }
      } on Exception catch (e) {
        logger.e(e);
        return const ApiResult.error("Error saving data");
      }
    }
  }

  @override
  Future<ApiResult<AddToCartEntity>> getAddToCartProducts(
      List<ProductAddCartParams> params, String id) async {
    if (!(await internetConnectionChecker.hasConnection)) {
      return const ApiResult.noInternetConenction();
    } else {
      try {
        var listOfCartResponse = await addToCartApi(params, id);
        return ApiResult.success(listOfCartResponse);
      } catch (e) {
        error(e);
        return ApiResult.error("An Error Occueed: $e");
      }
    }
  }
}
