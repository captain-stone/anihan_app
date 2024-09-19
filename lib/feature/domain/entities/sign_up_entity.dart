import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class SignUpEntity extends AppEntity {
  final String? phoneNumber;
  final String? emailAddress;
  final String? fullName;
  final String? password;

  SignUpEntity(
      {this.phoneNumber, this.emailAddress, this.fullName, this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber, emailAddress, fullName, password];
}
