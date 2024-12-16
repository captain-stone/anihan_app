import 'dart:typed_data';

import 'package:anihan_app/feature/domain/parameters/params.dart';

class JournalEntryParams extends Params {
  final String date;
  final String title;
  final String description;
  final List<Uint8List> photos;

  JournalEntryParams(
      {required this.date,
      required this.title,
      required this.description,
      this.photos = const []});

  @override
  List<Object?> get props => [
        date,
        title,
        description,
        photos,
      ];
}
