import 'package:anihan_app/feature/data/models/dto/community_post_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar_task_dto.g.dart';

@JsonSerializable()
class CalendarTaskDateDto {
  final String dateTime;
  final List<CalendarTaskDto> data;

  CalendarTaskDateDto({required this.dateTime, required this.data});

  // CalendarTaskDateDto copyWith({})

  factory CalendarTaskDateDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarTaskDateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarTaskDateDtoToJson(this);
}

@JsonSerializable()
class CalendarTaskDto {
  final String? id;
  final String name;
  String status;

  CalendarTaskDto({this.id, required this.name, required this.status});

  CalendarTaskDto copyWith({String? id}) {
    return CalendarTaskDto(id: id ?? this.id, name: name, status: status);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'status': status,
      };

  factory CalendarTaskDto.fromMap(Map<String, dynamic> map) =>
      CalendarTaskDto(name: map['name'], status: map['status']);

  factory CalendarTaskDto.fromJson(Map<String, dynamic> json) =>
      _$CalendarTaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarTaskDtoToJson(this);
}
