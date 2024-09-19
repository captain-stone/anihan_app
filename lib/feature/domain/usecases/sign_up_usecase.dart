import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/impl/session_repo_impl.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/sessions_repositories.dart';
import 'package:anihan_app/feature/domain/usecases/usecases.dart';
import 'package:injectable/injectable.dart';

import '../entities/sign_up_entity.dart';
import '../parameters/sign_up_params.dart';

@injectable
class SignUpUsecase
    extends Usecases<Future<ApiResult<SignUpEntity>>, SignUpParams> {
  final SessionsRepositories _repositories;

  SignUpUsecase(this._repositories);

  @override
  call(SignUpParams params) => _repositories.getSignUpEntity(params);
}
