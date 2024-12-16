part of 'weather_widget_bloc.dart';

abstract class WeatherWidgetEvent extends Equatable {
  const WeatherWidgetEvent();
}

class GetWeatherDataEvent extends WeatherWidgetEvent {
  const GetWeatherDataEvent();
  @override
  List<Object> get props => [];
}
