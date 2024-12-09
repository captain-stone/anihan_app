import 'package:anihan_app/feature/domain/entities/app_entity.dart';

class CommunityData extends AppEntity {
  final String name;
  final String ownerId;
  final Map<String, dynamic>? members;
  final DateTime createdAt;

  CommunityData({
    required this.name,
    required this.ownerId,
    required this.createdAt,
    this.members,
  });
  @override
  List<Object?> get props => [
        name,
        ownerId,
        createdAt,
        members,
      ];
}
