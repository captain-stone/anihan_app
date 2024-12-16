// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarTaskDateDto _$CalendarTaskDateDtoFromJson(Map<String, dynamic> json) =>
    CalendarTaskDateDto(
      dateTime: json['dateTime'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => CalendarTaskDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CalendarTaskDateDtoToJson(
        CalendarTaskDateDto instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime,
      'data': instance.data,
    };

CalendarTaskDto _$CalendarTaskDtoFromJson(Map<String, dynamic> json) =>
    CalendarTaskDto(
      id: json['id'] as String?,
      name: json['name'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$CalendarTaskDtoToJson(CalendarTaskDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
    };
