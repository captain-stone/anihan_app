import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/parameters/journal_entry_params.dart';

part 'journal_entry_dto.g.dart';

@JsonSerializable()
class JournalEntryDto {
  final String? id;
  final String date;
  final String title;
  final String description;
  final List<String> photos;

  JournalEntryDto({
    this.id,
    required this.date,
    required this.title,
    required this.description,
    this.photos = const [],
  });

  factory JournalEntryDto.fromParams(JournalEntryParams params) {
    return JournalEntryDto(
      date: params.date,
      title: params.title,
      description: params.description,
      // photos: convertedImage,
    );
  }

  JournalEntryParams toParams() {
    return JournalEntryParams(
      date: date,
      title: title,
      description: description,
      // photos: convertedString,
    );
  }

  JournalEntryDto copyWith({String? id}) {
    return JournalEntryDto(
      id: id ?? this.id,
      date: date,
      title: title,
      description: description,
      photos: photos,
    );
  }

  JournalEntryDto addImageListWith({List<String>? images}) {
    return JournalEntryDto(
      id: id,
      date: date,
      title: title,
      description: description,
      photos: images ?? this.photos,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'title': title,
        'description': description,
        'photos': photos
      };

  Map<String, dynamic> addImageList() => {
        'date': date,
        'title': title,
        'description': description,
        'photos': photos
      };

  factory JournalEntryDto.fromMap(Map<String, dynamic> map) => JournalEntryDto(
      id: map.containsKey('id') ? map["id"] : "None",
      date: map["date"],
      title: map["title"],
      description: map["description"],
      photos: map.containsKey('photos')
          ? List<String>.from(map["photos"] as List<Object?>)
          : []);

  factory JournalEntryDto.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryDtoToJson(this);
}
