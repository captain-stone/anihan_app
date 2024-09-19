import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/app_repository.dart';
import 'package:anihan_app/feature/domain/entities/login_entity.dart';
import 'package:anihan_app/feature/domain/entities/sign_up_entity.dart';
import 'package:anihan_app/feature/domain/parameters/login_params.dart';
import 'package:anihan_app/feature/domain/parameters/sign_up_params.dart';

abstract class SessionsRepositories extends AppRepository {
  Future<ApiResult<LoginEntity>> getLoginEntity(LoginParams? params);
  Future<ApiResult<SignUpEntity>> getSignUpEntity(SignUpParams params);
}
