import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/user_information_repository.dart';
import 'package:anihan_app/feature/domain/entities/user_information_and_data_entity.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';

import '../../models/api/user_information_service_api.dart';

@Injectable(as: UserInformationRepository)
class UserInformationRepoImpl extends UserInformationRepository {
  final Logger logger = Logger();
  final InternetConnectionChecker internetConnectionChecker;

  UserInformationRepoImpl(@Named('global') this.internetConnectionChecker);

  @override
  Future<ApiResult<UserInformationEntity>> getUserData(
      UserUidParams params) async {
    //internet first

    UserInformationServiceApi userInformationServiceApi =
        UserInformationServiceApi();

    if (!(await internetConnectionChecker.hasConnection)) {
      return ApiResult.noInternetConenction();
    } else {
      var result = await userInformationServiceApi.userInformation(params.uid);

      // var useData = result["users"];
      // var informationData = result["databaseData"];
      var entity = result.toEntity();

      logger.d(entity);

      return ApiResult.success(entity);
    }
    // // TODO: implement getUserData
    // throw UnimplementedError();
  }
}
