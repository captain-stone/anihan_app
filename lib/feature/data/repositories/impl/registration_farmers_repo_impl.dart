import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/user_information_service_api.dart';
import 'package:anihan_app/feature/domain/entities/registration_farmers_entity.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';

import '../interfaces/registration_farmers_repository.dart';

@Injectable(as: RegistrationFarmersRepository)
class RegistrationFarmersRepoImpl extends RegistrationFarmersRepository {
  final logger = Logger();
  final InternetConnectionChecker internetConnectionChecker;

  RegistrationFarmersRepoImpl(@Named('global') this.internetConnectionChecker);
  @override
  Future<ApiResult<RegistrationFarmersEntity>> getFarmerApproval(
      FarmersRegistrationParams params) async {
    //adding farms informations.
    //adding store informations
    //adding data information

    if (!(await internetConnectionChecker.hasConnection)) {
      return ApiResult.noInternetConenction();
    } else {
      try {
        UserInformationServiceApi userInformationServiceApi =
            UserInformationServiceApi();
        var returnedData =
            await userInformationServiceApi.sellersInformation(params);

        logger.d(returnedData);

        if (returnedData.isApprove != null) {
          return ApiResult.success(returnedData.toEntity());
        } else {
          return const ApiResult.error("Error saving data");
        }
      } on Exception catch (e) {
        // TODO
        logger.e(e);
        return ApiResult.error("Error saving data");
      }
    }
  }
}
