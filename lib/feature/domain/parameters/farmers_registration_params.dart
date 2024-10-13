import 'package:anihan_app/feature/domain/parameters/params.dart';

class FarmersRegistrationParams extends Params {
  final String storeName;
  final String onlineTime;
  final String storeAddress;
  final String password;

  FarmersRegistrationParams(
      {required this.storeName,
      required this.onlineTime,
      required this.storeAddress,
      required this.password});
  @override
  List<Object?> get props => [storeName, onlineTime, storeAddress, password];
}
