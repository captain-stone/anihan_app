// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntryDto _$JournalEntryDtoFromJson(Map<String, dynamic> json) =>
    JournalEntryDto(
      id: json['id'] as String?,
      date: json['date'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$JournalEntryDtoToJson(JournalEntryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'title': instance.title,
      'description': instance.description,
      'photos': instance.photos,
    };
