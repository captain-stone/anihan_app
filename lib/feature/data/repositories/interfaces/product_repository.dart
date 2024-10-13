import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/app_repository.dart';
import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_params.dart';

abstract class ProductRepository extends AppRepository {
  Future<ApiResult<List<ProductEntity>>> getProducts(ProductParams params);
  // Future<ApiResult<ProductEntity>> addProduct(ProductParams params);
}
