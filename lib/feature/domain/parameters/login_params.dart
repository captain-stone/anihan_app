import 'package:anihan_app/feature/domain/parameters/params.dart';

class LoginParams extends Params {
  final String username;
  final String password;

  LoginParams(this.username, this.password);
  @override
  List<Object> get props => [username, password];
}
