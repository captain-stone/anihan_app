import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class UserInformationEntity extends AppEntity {
  final String displayName;
  final String remarks; //this will remarks as farmers or user only
  final String? photoImage;
  final String emailAddress;
  final String? address;
  final int phoneNumber;

  UserInformationEntity(
    this.displayName,
    this.remarks,
    this.emailAddress,
    this.phoneNumber, {
    this.address,
    this.photoImage,
  });
  // final String
  @override
  List<Object?> get props => [
        displayName,
        remarks,
        photoImage,
        emailAddress,
        address,
        phoneNumber,
      ];
}
