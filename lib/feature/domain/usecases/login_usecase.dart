import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/sessions_repositories.dart';
import 'package:anihan_app/feature/domain/usecases/usecases.dart';
import 'package:injectable/injectable.dart';

import '../entities/login_entity.dart';
import '../parameters/login_params.dart';

@injectable
class LoginUsecase
    extends Usecases<Future<ApiResult<LoginEntity>>, LoginParams> {
  final SessionsRepositories _repositories;

  LoginUsecase(this._repositories);

  @override
  call(LoginParams? params) => _repositories.getLoginEntity(params);
}
