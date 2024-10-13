import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/user_information_repository.dart';
import 'package:anihan_app/feature/domain/entities/user_information_and_data_entity.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';
import 'package:anihan_app/feature/domain/usecases/usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserInformationUsecase
    extends Usecases<Future<ApiResult<UserInformationEntity>>, UserUidParams> {
  final UserInformationRepository _repository;

  UserInformationUsecase(this._repository);
  @override
  call(UserUidParams params) => _repository.getUserData(params);
}
