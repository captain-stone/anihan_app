import 'package:anihan_app/feature/domain/entities/app_entity.dart';
import 'package:anihan_app/feature/domain/entities/registration_farmers_entity.dart';
import 'package:anihan_app/feature/presenter/gui/pages/seller_registration_bloc/seller_registration_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import 'app_dto.dart';

part 'seller_registrations_dto.g.dart';

@JsonSerializable()
class SellerRegistrationsDto extends AppDto {
  final String storeName;
  final String storeAddress;
  final String? isApprove;

  SellerRegistrationsDto(
      {required this.storeName, required this.storeAddress, this.isApprove});
  @override
  RegistrationFarmersEntity toEntity() => RegistrationFarmersEntity(
      storeName: storeName, storeAddress: storeAddress, isApprove: isApprove);

  factory SellerRegistrationsDto.fromJson(Map<String, dynamic> json) =>
      _$SellerRegistrationsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SellerRegistrationsDtoToJson(this);
}
