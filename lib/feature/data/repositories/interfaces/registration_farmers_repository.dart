import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/app_repository.dart';
import 'package:anihan_app/feature/domain/entities/registration_farmers_entity.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';

abstract class RegistrationFarmersRepository extends AppRepository {
  Future<ApiResult<RegistrationFarmersEntity>> getFarmerApproval(
      FarmersRegistrationParams params);
}
