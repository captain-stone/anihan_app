import 'package:anihan_app/feature/data/models/dto/app_dto.dart';
import 'package:anihan_app/feature/domain/entities/app_entity.dart';
import 'package:anihan_app/feature/presenter/gui/pages/Loyalty/bloc/rewards_bloc.dart';

import 'package:json_annotation/json_annotation.dart';

part 'forecast_list_dto.g.dart';

@JsonSerializable()
class ForecaseListDto {
  final String date;
  final String icon;
  final String description;
  final String heatIndex;
  final String rainProbability;
  final String typhoonAlert;
  final String uvIndex;
  final String soilMoisture;
  final String windSpeed;
  final String windDirection;
  final String humidity;

  ForecaseListDto({
    required this.date,
    required this.icon,
    required this.description,
    required this.heatIndex,
    required this.rainProbability,
    required this.typhoonAlert,
    required this.uvIndex,
    required this.soilMoisture,
    required this.windSpeed,
    required this.windDirection,
    required this.humidity,
  });
}
