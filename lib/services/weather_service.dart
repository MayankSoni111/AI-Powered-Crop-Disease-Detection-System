import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import 'api_config.dart';

/// Weather API Service — OpenWeatherMap Integration
///
/// API: OpenWeatherMap (https://openweathermap.org/api)
/// Free tier: 60 calls/min
///
/// Endpoints used:
///   GET /weather          → Current weather
///   GET /forecast         → 5-day / 3-hour forecast
///   GET /uvi              → UV index
///   GET /geo/1.0/reverse  → Reverse geocoding (coordinates → city name)
///
/// Setup:
///   1. Sign up at https://openweathermap.org/api
///   2. Get your free API key
///   3. Paste it in api_config.dart → openWeatherMapApiKey
class WeatherService {
  /// Fetch current weather for given coordinates.
  Future<WeatherData> getCurrentWeather({double? lat, double? lon}) async {
    if (!ApiConfig.isWeatherConfigured || lat == null || lon == null) {
      return WeatherData.demo();
    }

    try {
      // Fetch current weather
      final weatherUrl =
          '${ApiConfig.openWeatherBaseUrl}/weather?lat=$lat&lon=$lon&appid=${ApiConfig.openWeatherMapApiKey}&units=metric';
      final weatherResponse = await http
          .get(Uri.parse(weatherUrl))
          .timeout(ApiConfig.apiTimeout);

      if (weatherResponse.statusCode == 200) {
        final data = json.decode(weatherResponse.body);
        final weather = WeatherData.fromOpenWeatherMap(data);

        // Fetch UV index separately
        final uvUrl =
            '${ApiConfig.openWeatherBaseUrl}/uvi?lat=$lat&lon=$lon&appid=${ApiConfig.openWeatherMapApiKey}';
        try {
          final uvResponse = await http
              .get(Uri.parse(uvUrl))
              .timeout(ApiConfig.apiTimeout);
          if (uvResponse.statusCode == 200) {
            final uvData = json.decode(uvResponse.body);
            return WeatherData(
              temperature: weather.temperature,
              humidity: weather.humidity,
              windSpeed: weather.windSpeed,
              rainProbability: weather.rainProbability,
              uvIndex: (uvData['value'] ?? 0).toDouble(),
              description: weather.description,
              icon: weather.icon,
              date: weather.date,
              cityName: weather.cityName,
            );
          }
        } catch (_) {
          // UV API failed, return weather without UV
        }

        return weather;
      }
      return WeatherData.demo();
    } catch (e) {
      return WeatherData.demo();
    }
  }

  /// Fetch 7-day forecast from 5-day/3-hour forecast API.
  /// Groups readings by day, picking the midday reading.
  Future<List<WeatherData>> getForecast({double? lat, double? lon}) async {
    if (!ApiConfig.isWeatherConfigured || lat == null || lon == null) {
      return _generateDemoForecast();
    }

    try {
      final url =
          '${ApiConfig.openWeatherBaseUrl}/forecast?lat=$lat&lon=$lon&appid=${ApiConfig.openWeatherMapApiKey}&units=metric&cnt=40';
      final response = await http
          .get(Uri.parse(url))
          .timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = data['list'] as List;

        // Group by day and pick midday (12:00) reading per day
        final Map<String, WeatherData> dailyForecasts = {};
        for (var item in list) {
          final weather = WeatherData.fromOpenWeatherMap(item);
          final dayKey =
              '${weather.date.year}-${weather.date.month}-${weather.date.day}';

          // Prefer midday reading, otherwise take first reading of the day
          if (!dailyForecasts.containsKey(dayKey) ||
              (weather.date.hour >= 11 && weather.date.hour <= 14)) {
            dailyForecasts[dayKey] = weather;
          }
        }

        // Skip today, return next 7 days
        final today =
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
        dailyForecasts.remove(today);

        return dailyForecasts.values.take(7).toList();
      }
      return _generateDemoForecast();
    } catch (e) {
      return _generateDemoForecast();
    }
  }

  /// Reverse geocode coordinates → city name.
  Future<String> getCityName(double lat, double lon) async {
    if (!ApiConfig.isWeatherConfigured) return 'Your Location';

    try {
      final url =
          '${ApiConfig.openWeatherGeoUrl}/reverse?lat=$lat&lon=$lon&limit=1&appid=${ApiConfig.openWeatherMapApiKey}';
      final response = await http
          .get(Uri.parse(url))
          .timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        if (data.isNotEmpty) {
          return '${data[0]['name']}, ${data[0]['state'] ?? data[0]['country']}';
        }
      }
      return 'Your Location';
    } catch (e) {
      return 'Your Location';
    }
  }

  /// Demo forecast data for offline/demo mode.
  List<WeatherData> _generateDemoForecast() {
    return List.generate(7, (i) {
      final day = DateTime.now().add(Duration(days: i + 1));
      return WeatherData(
        temperature: 28 + (i * 1.5) - (i > 3 ? 5 : 0),
        humidity: 60 + (i * 5) - (i > 4 ? 15 : 0),
        windSpeed: 10 + (i * 2),
        rainProbability: i == 2 || i == 5 ? 75 : 20,
        uvIndex: 6 + (i % 3),
        description: i == 2
            ? 'Heavy rain'
            : i == 5
                ? 'Thunderstorm'
                : 'Partly cloudy',
        icon: i == 2 || i == 5 ? '10d' : '02d',
        date: day,
      );
    });
  }
}
