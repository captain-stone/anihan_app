import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/dto/app_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:anihan_app/feature/domain/entities/app_entity.dart';
import 'package:anihan_app/feature/domain/entities/user_information_and_data_entity.dart';

part 'user_information_dto.g.dart';

@JsonSerializable()
class UserInformationDto extends AppDto {
  final String displayName;
  final String remarks;
  final String emailAddress;
  final int phoneNumber;
  final String? photoUrl;

  UserInformationDto(
      this.displayName, this.remarks, this.emailAddress, this.phoneNumber,
      {this.photoUrl});
  @override
  UserInformationEntity toEntity() =>
      UserInformationEntity(displayName, remarks, emailAddress, phoneNumber,
          photoImage: photoUrl);

  factory UserInformationDto.fromJson(Map<String, dynamic> json) =>
      _$UserInformationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInformationDtoToJson(this);
}
