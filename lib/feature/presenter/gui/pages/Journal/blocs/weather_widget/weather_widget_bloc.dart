import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/api/weather_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'weather_widget_event.dart';
part 'weather_widget_state.dart';

@injectable
class WeatherWidgetBloc extends Bloc<WeatherWidgetEvent, WeatherWidgetState> {
  final WeatherApi _weatherApi = WeatherApi();
  WeatherWidgetBloc() : super(WeatherWidgetInitial()) {
    on<GetWeatherDataEvent>((event, emit) async {
      emit(const WeatherWidgetLoadingState());
      var result = await _weatherApi.getWeatherData();

      Status status = result.status;

      if (status != Status.error) {
        var data = result.data;

        if (data != null) {
          emit(WeatherWidgetSuccessState(data));
        } else {
          emit(WeatherWidgetErrorState(result.message!));
        }
      } else {
        emit(WeatherWidgetErrorState(result.message!));
      }
    });
  }
}
