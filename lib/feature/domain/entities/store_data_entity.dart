import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class StoreDataEntity extends AppEntity {
  final int createdAt;
  final String storeName;
  final String storeLocation;
  final String storeAddress;

  StoreDataEntity(
      {required this.createdAt,
      required this.storeName,
      required this.storeLocation,
      required this.storeAddress});
  @override
  List<Object?> get props => [
        createdAt,
        storeName,
        storeLocation,
        storeAddress,
      ];
}
