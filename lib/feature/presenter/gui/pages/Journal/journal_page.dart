import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/weather_widget.dart';
import 'widgets/journal_entries_widget.dart';
import 'widgets/ai_help_widget.dart';
import 'blocs/calendar_bloc.dart';
import 'blocs/journal_bloc.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({Key? key}) : super(key: key);

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
      body: BlocProvider(
        create: (context) => CalendarBloc(),
        child: Stack(
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
                  const WeatherForecastWidget(
                    forecastData: [
                      {
                        'date': 'Mon',
                        'icon': 'https://openweathermap.org/img/wn/01d@2x.png',
                        'temperature': 32,
                        'description': 'Sunny',
                        'heatIndex': 40,
                        'rainProbability': 10,
                        'typhoonAlert': 'None',
                        'uvIndex': 8,
                        'soilMoisture': 50,
                        'windSpeed': 12,
                        'windDirection': 'NE',
                        'humidity': 60,
                      },
                      {
                        'date': 'Tue',
                        'icon': 'https://openweathermap.org/img/wn/02d@2x.png',
                        'temperature': 31,
                        'description': 'Partly Cloudy',
                        'heatIndex': 38,
                        'rainProbability': 20,
                        'typhoonAlert': 'None',
                        'uvIndex': 7,
                        'soilMoisture': 55,
                        'windSpeed': 15,
                        'windDirection': 'E',
                        'humidity': 65,
                      },
                      {
                        'date': 'Wed',
                        'icon': 'https://openweathermap.org/img/wn/10d@2x.png',
                        'temperature': 28,
                        'description': 'Rainy',
                        'heatIndex': 33,
                        'rainProbability': 80,
                        'typhoonAlert': 'None',
                        'uvIndex': 5,
                        'soilMoisture': 70,
                        'windSpeed': 20,
                        'windDirection': 'SE',
                        'humidity': 85,
                      },
                      {
                        'date': 'Thu',
                        'icon': 'https://openweathermap.org/img/wn/11d@2x.png',
                        'temperature': 26,
                        'description': 'Thunderstorms',
                        'heatIndex': 29,
                        'rainProbability': 90,
                        'typhoonAlert': 'Low Risk',
                        'uvIndex': 3,
                        'soilMoisture': 80,
                        'windSpeed': 30,
                        'windDirection': 'S',
                        'humidity': 90,
                      },
                      {
                        'date': 'Fri',
                        'icon': 'https://openweathermap.org/img/wn/04d@2x.png',
                        'temperature': 30,
                        'description': 'Cloudy',
                        'heatIndex': 35,
                        'rainProbability': 50,
                        'typhoonAlert': 'None',
                        'uvIndex': 6,
                        'soilMoisture': 60,
                        'windSpeed': 18,
                        'windDirection': 'SW',
                        'humidity': 70,
                      },
                      {
                        'date': 'Sat',
                        'icon': 'https://openweathermap.org/img/wn/01d@2x.png',
                        'temperature': 34,
                        'description': 'Hot and Humid',
                        'heatIndex': 45,
                        'rainProbability': 5,
                        'typhoonAlert': 'None',
                        'uvIndex': 9,
                        'soilMoisture': 45,
                        'windSpeed': 10,
                        'windDirection': 'NW',
                        'humidity': 55,
                      },
                      {
                        'date': 'Sun',
                        'icon': 'https://openweathermap.org/img/wn/11d@2x.png',
                        'temperature': 27,
                        'description': 'Typhoon Warning',
                        'heatIndex': 28,
                        'rainProbability': 100,
                        'typhoonAlert': 'High Risk',
                        'uvIndex': 2,
                        'soilMoisture': 90,
                        'windSpeed': 50,
                        'windDirection': 'W',
                        'humidity': 95,
                      },
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  const JournalEntriesWidget(),
                ],
              ),
            ),
            const AIHelpWidget(),
          ],
        ),
      ),
    );
  }
}
