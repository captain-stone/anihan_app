import 'package:anihan_app/feature/domain/parameters/params.dart';

class SignUpParams extends Params {
  final int phoneNumber;
  final String emailAddress;
  final String fullName;
  final String password;

  SignUpParams(
      this.phoneNumber, this.emailAddress, this.fullName, this.password);

  @override
  List<Object?> get props => [phoneNumber, emailAddress, fullName, password];
}
