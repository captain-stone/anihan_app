import 'package:anihan_app/feature/domain/parameters/params.dart';

class UserUidParams extends Params {
  final String uid;
  UserUidParams(this.uid);
  @override
  // TODO: implement props
  List<Object?> get props => [uid];
}
