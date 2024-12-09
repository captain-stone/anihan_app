import 'package:anihan_app/feature/domain/parameters/params.dart';

class UserUidParams extends Params {
  final String uid;
  UserUidParams(this.uid);
  @override
  List<Object?> get props => [uid];
}

class UserAddressParams extends Params {
  final String uid;
  final String address;

  UserAddressParams(this.uid, this.address);

  @override
  // TODO: implement props
  List<Object?> get props => [uid, address];
}
