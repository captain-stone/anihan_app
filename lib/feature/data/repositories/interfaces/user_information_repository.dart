import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/app_repository.dart';
import 'package:anihan_app/feature/domain/entities/login_entity.dart';
import 'package:anihan_app/feature/domain/entities/user_information_and_data_entity.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';

abstract class UserInformationRepository extends AppRepository {
  Future<ApiResult<UserInformationEntity>> getUserData(UserUidParams params);

  Future<ApiResult<LoginEntity>> getLoginEntity();
}
