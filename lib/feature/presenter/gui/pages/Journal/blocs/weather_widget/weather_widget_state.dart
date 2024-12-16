part of 'weather_widget_bloc.dart';

sealed class WeatherWidgetState extends Equatable {
  const WeatherWidgetState();
}

final class WeatherWidgetInitial extends WeatherWidgetState {
  @override
  List<Object> get props => [];
}

class WeatherWidgetLoadingState extends WeatherWidgetState {
  const WeatherWidgetLoadingState();
  @override
  List<Object> get props => [];
}

class WeatherWidgetSuccessState extends WeatherWidgetState {
  final List<Map<String, dynamic>> data;
  const WeatherWidgetSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

final class WeatherWidgetErrorState extends WeatherWidgetState {
  final String message;
  const WeatherWidgetErrorState(this.message);
  @override
  List<Object> get props => [message];
}
