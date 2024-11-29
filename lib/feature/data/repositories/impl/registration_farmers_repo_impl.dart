import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/user_information_service_api.dart';
import 'package:anihan_app/feature/domain/entities/registration_farmers_entity.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      return const ApiResult.noInternetConenction();
    } else {
      try {
        // User user =

        UserInformationServiceApi userInformationServiceApi =
            UserInformationServiceApi();

        User user = await userInformationServiceApi.gettingUserId();

        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: user.email!, password: params.password);

        var returnedData =
            await userInformationServiceApi.sellersInformation(params);

        if (returnedData.isApprove != null) {
          return ApiResult.success(returnedData.toEntity());
        } else {
          return const ApiResult.error("Error saving data");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          return const ApiResult.error(
              "Your password is Incorrect. Please try again and use the correct password");
        } else {
          return const ApiResult.error("Error saving data");
        }
      } on Exception catch (e) {
        logger.e(e);
        return const ApiResult.error("Error saving data");
      }
    }
  }
}
