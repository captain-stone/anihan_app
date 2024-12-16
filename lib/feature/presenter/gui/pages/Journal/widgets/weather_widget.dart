import 'package:flutter/material.dart';

class WeatherForecastWidget extends StatefulWidget {
  final List<Map<String, dynamic>> forecastData;

  const WeatherForecastWidget({
    super.key,
    required this.forecastData,
  });

  @override
  _WeatherForecastWidgetState createState() => _WeatherForecastWidgetState();
}

class _WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  late Map<String, dynamic> _currentForecast;

  @override
  void initState() {
    super.initState();
    _currentForecast = widget.forecastData[0];
  }

  void _updateCurrentForecast(Map<String, dynamic> selectedForecast) {
    setState(() {
      _currentForecast = selectedForecast;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12.0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Forecast Display
            Row(
              children: [
                // Weather Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Image.network(
                      _currentForecast['icon'],
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.wb_sunny,
                          size: 50,
                          color: Colors.orange,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_currentForecast['temperature']}°C',
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        _currentForecast['description'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Additional Data Display with Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildDataItem(
                        context,
                        icon: Icons.thermostat,
                        label: 'Heat Index',
                        value: '${_currentForecast['heatIndex']}°C',
                      ),
                      _buildDataItem(
                        context,
                        icon: Icons.water_drop,
                        label: 'Rain Prob',
                        value: '${_currentForecast['rainProbability']}%',
                      ),
                      _buildDataItem(
                        context,
                        icon: Icons.wb_sunny,
                        label: 'UV Index',
                        value: '${_currentForecast['uvIndex']}',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildDataItem(
                        context,
                        icon: Icons.warning,
                        label: 'Typhoon Alert',
                        value: _currentForecast['typhoonAlert'],
                      ),
                      _buildDataItem(
                        context,
                        icon: Icons.grass,
                        label: 'Soil Moisture',
                        value: '${_currentForecast['soilMoisture']}%',
                      ),
                      _buildDataItem(
                        context,
                        icon: Icons.air,
                        label: 'Wind',
                        value:
                            '${_currentForecast['windSpeed']} km/h (${_currentForecast['windDirection']})',
                      ),
                      _buildDataItem(
                        context,
                        icon: Icons.opacity,
                        label: 'Humidity',
                        value: '${_currentForecast['humidity']}%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Divider(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              thickness: 1.0,
            ),
            const SizedBox(height: 8.0),
            // Horizontal Slider for 7-Day Forecast
            SizedBox(
              height: 120.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.forecastData.length,
                itemBuilder: (context, index) {
                  final dayData = widget.forecastData[index];
                  return GestureDetector(
                    onTap: () => _updateCurrentForecast(dayData),
                    child: _buildForecastCard(context, dayData),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard(
      BuildContext context, Map<String, dynamic> dayData) {
    return Container(
      width: 100.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayData['date'],
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6.0),
          Image.network(
            dayData['icon'],
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.cloud,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              );
            },
          ),
          const SizedBox(height: 6.0),
          Text(
            '${dayData['temperature']}°C',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
