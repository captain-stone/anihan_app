import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String imageUrl;
  final String name;
  final int availableToClaim;
  final int maxPerPerson;

  const Product({
    required this.imageUrl,
    required this.name,
    required this.availableToClaim,
    required this.maxPerPerson,
  });

  @override
  List<Object?> get props => [imageUrl, name, availableToClaim, maxPerPerson];
}
