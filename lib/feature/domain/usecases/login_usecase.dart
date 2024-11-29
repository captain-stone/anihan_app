import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/sessions_repositories.dart';
import 'package:anihan_app/feature/domain/parameters/params.dart';
import 'package:anihan_app/feature/domain/usecases/usecases.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/interfaces/user_information_repository.dart';
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

@injectable
class LogoutUsecase extends Usecases<Future<ApiResult<LoginEntity>>, NoParams> {
  final UserInformationRepository _repositories;

  LogoutUsecase(this._repositories);

  @override
  call(NoParams params) => _repositories.getLoginEntity();
}
