import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/presenter/gui/pages/Journal/blocs/journal_widget/journal_widget_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/pages/Journal/blocs/weather_widget/weather_widget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../../../services/degree_to_string.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/weather_widget.dart';
import 'widgets/journal_entries_widget.dart';
import 'widgets/ai_help_widget.dart';
import 'blocs/calendar_bloc.dart';
import 'blocs/journal_bloc.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _journalBloc = getIt<JournalWidgetBloc>();
  final _weatherBloc = getIt<WeatherWidgetBloc>();
  List<Map<String, dynamic>> forecastData = [];
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _weatherBloc.add(const GetWeatherDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Journal',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Your existing widgets (e.g., Calendar, Journal, Weather)
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar Widget Section
                Text(
                  'Your Calendar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16.0),
                CalendarWidget(),
                // Weather Widget Section
                const SizedBox(height: 16.0),
                BlocBuilder<WeatherWidgetBloc, WeatherWidgetState>(
                  bloc: _weatherBloc,
                  builder: (context, state) {
                    logger.d(state);
                    if (state is WeatherWidgetSuccessState) {
                      var dataList = state.data;

                      for (var currentDataMap in dataList) {
                        var date = currentDataMap["dt_txt"];
                        // DateTime dateToCompare = DateTime.parse(date);
                        // DateTime currentDateOnly = DateTime(DateTime.now().year,
                        //     DateTime.now().month, DateTime.now().day);

                        // if (dateToCompare.year == currentDateOnly.year &&
                        //     dateToCompare.month == currentDateOnly.month &&
                        //     dateToCompare.day == currentDateOnly.day) {
                        //   logger.d(currentDataMap);
                        double kelvin = currentDataMap['main']['temp_max'];
                        double kelvinTemp = currentDataMap['main']['temp'];
                        double celsius = kelvin - 273.15;
                        double celsiusTemp = kelvinTemp - 273.15;
                        // logger.d(currentDataMap);

                        var data = {
                          'date':
                              DateFormat('EEEE').format(DateTime.parse(date)),
                          'icon':
                              'https://openweathermap.org/img/wn/${currentDataMap['weather'][0]['icon']}.png',
                          'temperature':
                              double.parse(celsiusTemp.toStringAsFixed(1)),
                          'description': currentDataMap['weather'][0]
                              ['description'],
                          'heatIndex': double.parse(celsius.toStringAsFixed(1)),
                          'rainProbability': currentDataMap['pop'],
                          'typhoonAlert': 'None',
                          'uvIndex': 0,
                          'soilMoisture': 0,
                          'windSpeed': 12,
                          'windDirection': convertDegreesToDirection(
                              currentDataMap['wind']['deg']),
                          'humidity': currentDataMap['main']['humidity'],
                        };

                        forecastData.add(data);
                      }

                      return WeatherForecastWidget(
                        forecastData: forecastData,
                        // forecastData: [
                        //   {
                        //     'date': 'Mon',
                        //     'icon':
                        //         'https://openweathermap.org/img/wn/01d@2x.png',
                        //     'temperature': 32,
                        //     'description': 'Sunny',
                        //     'heatIndex': 40,
                        //     'rainProbability': 10,
                        //     'typhoonAlert': 'None',
                        //     'uvIndex': 8,
                        //     'soilMoisture': 50,
                        //     'windSpeed': 12,
                        //     'windDirection': 'NE',
                        //     'humidity': 60,
                        //   },
                        //   {
                        //     'date': 'Tue',
                        //     'icon':
                        //         'https://openweathermap.org/img/wn/02d@2x.png',
                        //     'temperature': 31,
                        //     'description': 'Partly Cloudy',
                        //     'heatIndex': 38,
                        //     'rainProbability': 20,
                        //     'typhoonAlert': 'None',
                        //     'uvIndex': 7,
                        //     'soilMoisture': 55,
                        //     'windSpeed': 15,
                        //     'windDirection': 'E',
                        //     'humidity': 65,
                        //   },
                        //   {
                        //     'date': 'Wed',
                        //     'icon':
                        //         'https://openweathermap.org/img/wn/10d@2x.png',
                        //     'temperature': 28,
                        //     'description': 'Rainy',
                        //     'heatIndex': 33,
                        //     'rainProbability': 80,
                        //     'typhoonAlert': 'None',
                        //     'uvIndex': 5,
                        //     'soilMoisture': 70,
                        //     'windSpeed': 20,
                        //     'windDirection': 'SE',
                        //     'humidity': 85,
                        //   },
                        //   {
                        //     'date': 'Thu',
                        //     'icon':
                        //         'https://openweathermap.org/img/wn/11d@2x.png',
                        //     'temperature': 26,
                        //     'description': 'Thunderstorms',
                        //     'heatIndex': 29,
                        //     'rainProbability': 90,
                        //     'typhoonAlert': 'Low Risk',
                        //     'uvIndex': 3,
                        //     'soilMoisture': 80,
                        //     'windSpeed': 30,
                        //     'windDirection': 'S',
                        //     'humidity': 90,
                        //   },
                        //   {
                        //     'date': 'Fri',
                        //     'icon':
                        //         'https://openweathermap.org/img/wn/04d@2x.png',
                        //     'temperature': 30,
                        //     'description': 'Cloudy',
                        //     'heatIndex': 35,
                        //     'rainProbability': 50,
                        //     'typhoonAlert': 'None',
                        //     'uvIndex': 6,
                        //     'soilMoisture': 60,
                        //     'windSpeed': 18,
                        //     'windDirection': 'SW',
                        //     'humidity': 70,
                        //   },
                        //   {
                        //     'date': 'Sat',
                        //     'icon':
                        //         'https://openweathermap.org/img/wn/01d@2x.png',
                        //     'temperature': 34,
                        //     'description': 'Hot and Humid',
                        //     'heatIndex': 45,
                        //     'rainProbability': 5,
                        //     'typhoonAlert': 'None',
                        //     'uvIndex': 9,
                        //     'soilMoisture': 45,
                        //     'windSpeed': 10,
                        //     'windDirection': 'NW',
                        //     'humidity': 55,
                        //   },
                        //   {
                        //     'date': 'Sun',
                        //     'icon':
                        //         'https://openweathermap.org/img/wn/11d@2x.png',
                        //     'temperature': 27,
                        //     'description': 'Typhoon Warning',
                        //     'heatIndex': 28,
                        //     'rainProbability': 100,
                        //     'typhoonAlert': 'High Risk',
                        //     'uvIndex': 2,
                        //     'soilMoisture': 90,
                        //     'windSpeed': 50,
                        //     'windDirection': 'W',
                        //     'humidity': 95,
                        //   },
                        // ],
                      );
                    }

                    if (state is WeatherWidgetLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Container();
                    // logger.d(forecastData);
                  },
                ),
                const SizedBox(height: 24.0),

                const JournalEntriesWidget(),
              ],
            ),
          ),
          const AIHelpWidget(),
        ],
      ),
    );
  }
}
