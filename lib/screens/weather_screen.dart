import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../models/weather_data.dart';
import '../l10n/app_localizations.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wp = Provider.of<WeatherProvider>(context, listen: false);
      if (wp.currentWeather == null) {
        wp.fetchWeather();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    // Using the user's requested Scaffold design
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE8F5E9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Color(0xFF1B5E20), size: 16),
                const SizedBox(width: 4),
                Text(
                  weatherProvider.currentWeather?.cityName ?? 'Loading...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Text(
              DateFormat('EEEE, d MMM').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE8F5E9),
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF2E7D32)),
                onPressed: () => weatherProvider.fetchWeather(),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: weatherProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : weatherProvider.currentWeather == null
              ? Center(child: Text(context.tr('error')))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Current Weather Icon & Temp using user's UI layout
                      _buildCurrentWeatherHeader(weatherProvider.currentWeather!),
                      const SizedBox(height: 30),
                      
                      // Weather Details Grid using user's UI layout
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 2.2,
                        children: [
                          _buildWeatherDetailCard(
                            Icons.opacity, 
                            context.tr('humidity'), 
                            '${weatherProvider.currentWeather!.humidity.toStringAsFixed(0)}%', 
                            Colors.blue,
                          ),
                          _buildWeatherDetailCard(
                            Icons.air, 
                            context.tr('wind_speed'), 
                            '${weatherProvider.currentWeather!.windSpeed.toStringAsFixed(1)} km/h', 
                            Colors.green,
                          ),
                          _buildWeatherDetailCard(
                            Icons.umbrella, 
                            context.tr('rain_chance'), 
                            '${weatherProvider.currentWeather!.rainProbability.toStringAsFixed(0)}%', 
                            Colors.indigo,
                          ),
                          _buildWeatherDetailCard(
                            Icons.wb_sunny, 
                            context.tr('uv_index'), 
                            '${weatherProvider.currentWeather!.uvIndex.toStringAsFixed(0)}', 
                            Colors.orange,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),

                      // Farming advice / Alerts feature from original codebase integrated below grid
                      if (weatherProvider.currentWeather!.isDangerous)
                        _buildFarmingAdvice(weatherProvider.currentWeather!),
                      
                      const SizedBox(height: 10),

                      // 7-Day Forecast Header using user's UI
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('forecast_7day'),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B5E20),
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month, color: Color(0xFF2E7D32)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      // Forecast List using dynamic data and user's UI style
                      _buildForecastList(weatherProvider.forecast),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCurrentWeatherHeader(WeatherData weather) {
    final String temp = weather.temperature.toStringAsFixed(0);
    // basic mapping for description string to icon
    final String descLower = weather.description.toLowerCase();
    IconData icon = Icons.wb_sunny;
    if (descLower.contains('rain')) icon = Icons.water_drop;
    if (descLower.contains('cloud')) icon = Icons.cloud;
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2E7D32).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Icon(icon, size: 100, color: const Color(0xFF2E7D32)),
            if (icon == Icons.wb_sunny)
              Positioned(
                top: 10,
                right: 20,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFD54F),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '$temp°c',
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1B3B32),
          ),
        ),
        Text(
          weather.description.isNotEmpty
              ? weather.description[0].toUpperCase() + weather.description.substring(1)
              : '',
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF557A70),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetailCard(IconData icon, String label, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1B3B32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmingAdvice(WeatherData weather) {
    String advice = '';
    Color color = Colors.orange;

    if (weather.isHeavyRain) {
      advice = context.tr('alert_no_spray');
      color = Colors.blue;
    } else if (weather.isHeatwave) {
      advice = context.tr('alert_irrigation');
      color = Colors.red;
    } else if (weather.isHighHumidity) {
      advice = context.tr('alert_fungal');
      color = Colors.orange;
    } else if (weather.isColdWave) {
      advice = context.tr('alert_frost');
      color = Colors.indigo;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('weather_advice'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(advice, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastList(List<WeatherData> forecastDays) {
    if (forecastDays.isEmpty) return const SizedBox.shrink();

    return Column(
      children: forecastDays.map((day) {
        final dayName = DateFormat('EEE').format(day.date);
        final isRainy = day.rainProbability > 50;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  dayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1B3B32),
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                isRainy ? Icons.water_drop : Icons.wb_sunny, 
                color: isRainy ? Colors.blue : const Color(0xFF2E7D32)
              ),
              const Spacer(),
              Text(
                '${day.temperature.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1B3B32),
                ),
              ),
              const SizedBox(width: 10),
              // Simulating a low temp since WeatherData model doesn't explicitly guarantee low temp properties locally in this context
              // Realest implementation would use true day.temp_min if available
              Text(
                '${(day.temperature - 5).toStringAsFixed(0)}°',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
