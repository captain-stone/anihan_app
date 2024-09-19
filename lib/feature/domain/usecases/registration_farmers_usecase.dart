import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/registration_farmers_repository.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';
import 'package:anihan_app/feature/domain/usecases/usecases.dart';
import 'package:injectable/injectable.dart';

import '../entities/registration_farmers_entity.dart';

@injectable
class RegistrationFarmersUsecase extends Usecases<
    Future<ApiResult<RegistrationFarmersEntity>>, FarmersRegistrationParams> {
  final RegistrationFarmersRepository _repository;
  RegistrationFarmersUsecase(this._repository);
  @override
  call(FarmersRegistrationParams params) =>
      _repository.getFarmerApproval(params);
}
