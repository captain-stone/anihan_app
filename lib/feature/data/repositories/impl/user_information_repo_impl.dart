import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/user_information_repository.dart';
import 'package:anihan_app/feature/domain/entities/login_entity.dart';
import 'package:anihan_app/feature/domain/entities/user_information_and_data_entity.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';

import '../../models/api/user_information_service_api.dart';
import '../../models/dao/login_dao.dart';

@Injectable(as: UserInformationRepository)
class UserInformationRepoImpl extends UserInformationRepository {
  final Logger logger = Logger();
  final LoginDao loginDao;
  final InternetConnectionChecker internetConnectionChecker;

  UserInformationRepoImpl(
      @Named('global') this.internetConnectionChecker, this.loginDao);

  @override
  Future<ApiResult<UserInformationEntity>> getUserData(
      UserUidParams params) async {
    //internet first

    UserInformationServiceApi userInformationServiceApi =
        UserInformationServiceApi();

    if (!(await internetConnectionChecker.hasConnection)) {
      return const ApiResult.noInternetConenction();
    } else {
      try {
        var result =
            await userInformationServiceApi.userInformation(params.uid);

        // var useData = result["users"];
        // var informationData = result["databaseData"];
        var entity = result.toEntity();

        logger.d(entity);

        return ApiResult.success(entity);
      } on Exception catch (e) {
        logger.e(e);
        return const ApiResult.error("No User found");
      }
    }
  }

  @override
  Future<ApiResult<LoginEntity>> getLoginEntity() async {
    //check if there is data

    var loginEntityData = await loginDao.getLoginDao();

    if (loginEntityData != null) {
      await loginDao.deleteData();

      var data = await loginDao.getLoginDao();

      return ApiResult.success(data);
    } else {
      return const ApiResult.error("No Login Credentials");
    }
  }
}
