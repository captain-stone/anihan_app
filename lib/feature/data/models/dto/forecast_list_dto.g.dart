// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecaseListDto _$ForecaseListDtoFromJson(Map<String, dynamic> json) =>
    ForecaseListDto(
      date: json['date'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      heatIndex: json['heatIndex'] as String,
      rainProbability: json['rainProbability'] as String,
      typhoonAlert: json['typhoonAlert'] as String,
      uvIndex: json['uvIndex'] as String,
      soilMoisture: json['soilMoisture'] as String,
      windSpeed: json['windSpeed'] as String,
      windDirection: json['windDirection'] as String,
      humidity: json['humidity'] as String,
    );

Map<String, dynamic> _$ForecaseListDtoToJson(ForecaseListDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'icon': instance.icon,
      'description': instance.description,
      'heatIndex': instance.heatIndex,
      'rainProbability': instance.rainProbability,
      'typhoonAlert': instance.typhoonAlert,
      'uvIndex': instance.uvIndex,
      'soilMoisture': instance.soilMoisture,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'humidity': instance.humidity,
    };
