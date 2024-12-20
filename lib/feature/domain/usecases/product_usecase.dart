import 'package:anihan_app/common/api_result.dart';

import 'package:anihan_app/feature/data/repositories/interfaces/product_repository.dart';
import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_add_cart_params.dart';
import 'package:anihan_app/feature/domain/parameters/product_params.dart';
import 'package:anihan_app/feature/domain/usecases/usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductUsecase
    extends Usecases<Future<ApiResult<List<ProductEntity>>>, ProductParams> {
  final ProductRepository _repository;

  ProductUsecase(this._repository);
  @override
  call(ProductParams params) => _repository.getProducts(params);
}

@injectable
class AddToCartProductUsecase extends ListUsecase<
    Future<ApiResult<AddToCartEntity>>, ProductAddCartParams> {
  final ProductRepository _repository;

  AddToCartProductUsecase(this._repository);

  @override
  call(List<ProductAddCartParams> params, String id) =>
      _repository.getAddToCartProducts(params, id);
}
