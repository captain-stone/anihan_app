import 'dart:convert';

import 'package:anihan_app/common/api_result.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class WeatherApi {
  final logger = Logger();

  Future<ApiResult<List<Map<String, dynamic>>>> getWeatherData() async {
    final DateTime timeNow = DateTime.now();

    List<String> forecastTimes = [
      '06:00:00',
      '09:00:00',
      '12:00:00',
      '15:00:00',
      '18:00:00',
      '21:00:00',
      '00:00:00',
      '03:00:00',
    ];

    String nearestForecastTime = getNearestForecastTime(timeNow, forecastTimes);

    // DateTime approximateTime =
    //     DateTime(timeNow.year, timeNow.month, timeNow.day, timeNow.hour, 0, 0);

    List<Map<String, dynamic>> dataMap = [];
    var request = http.Request(
      'GET',
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?appid=39fec5f02e89aa24a74e4e08350a4056&lat=13&lon=122',
      ),
    );
// DateTime (2024-12-15 04:00:00.000)
    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Decode the response body
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> weatherData = jsonDecode(responseBody);

        var list = weatherData['list'];

        for (var mapItem in list) {
          String dtTxt = mapItem['dt_txt'];
          DateTime dtTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dtTxt);

          // DateTime roundedForecastTime = DateTime(
          //     dtTime.year, dtTime.month, dtTime.day, dtTime.hour, 0, 0);
          if (dtTime.hour == int.parse(nearestForecastTime.split(":")[0]) &&
              dtTime.minute == int.parse(nearestForecastTime.split(":")[1])) {
            // print('Matching forecast data: ${item}');
            dataMap.add(mapItem);
          }
        }

        // logger.d(dataMap);

        return ApiResult.success(dataMap);
      } else {
        logger.e('Failed to load weather data: ${response.reasonPhrase}');
        return ApiResult.error('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      logger.e('Error occurred: $e');
      return ApiResult.error('Error: $e');
    }
  }

  String getNearestForecastTime(
    DateTime currentTime,
    List<String> forecastTimes,
  ) {
    // Parse the forecast times into DateTime objects
    List<DateTime> forecastDateTimes = forecastTimes.map((time) {
      DateTime dateTime = DateFormat('HH:mm:ss').parse(time);
      return DateTime(currentTime.year, currentTime.month, currentTime.day,
          dateTime.hour, dateTime.minute);
    }).toList();

    // Find the closest forecast time
    DateTime nearestTime = forecastDateTimes.reduce((a, b) {
      // Compare the absolute difference in minutes between the two times
      int diffA = (a.isBefore(currentTime)
              ? currentTime.difference(a)
              : a.difference(currentTime))
          .inMinutes;
      int diffB = (b.isBefore(currentTime)
              ? currentTime.difference(b)
              : b.difference(currentTime))
          .inMinutes;

      // Return the one with the smaller difference
      return diffA < diffB ? a : b;
    });

    // Return the closest forecast time in HH:mm:ss format
    return DateFormat('HH:mm:ss').format(nearestTime);
  }
}
