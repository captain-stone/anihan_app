import 'package:anihan_app/feature/domain/entities/app_entity.dart';
import 'package:floor/floor.dart';

// @Entity(tableName: RegistrationFarmers.tableName)
class RegistrationFarmersEntity extends AppEntity {
  // @ignore
  // static const String tableName =
  final String storeName;
  final String storeAddress;
  final String? isApprove;

  RegistrationFarmersEntity(
      {required this.storeName, required this.storeAddress, this.isApprove});
  // final
  @override
  // TODO: implement props
  List<Object?> get props => [storeName, storeAddress, isApprove];
}
