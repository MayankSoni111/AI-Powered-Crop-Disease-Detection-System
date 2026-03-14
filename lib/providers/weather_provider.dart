import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';
import '../models/alert_model.dart';
import '../services/weather_service.dart';
import '../services/alert_service.dart';
import '../services/location_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherData? _currentWeather;
  List<WeatherData> _forecast = [];
  List<FarmAlert> _alerts = [];
  bool _isLoading = false;
  String? _error;
  String _cityName = '';

  WeatherData? get currentWeather => _currentWeather;
  List<WeatherData> get forecast => List.unmodifiable(_forecast);
  List<FarmAlert> get alerts => List.unmodifiable(_alerts);
  int get unreadAlertCount => _alerts.where((a) => !a.isRead).length;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get cityName => _cityName;

  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherProvider() {
    _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load current weather
      final currentJson = prefs.getString('cached_current_weather');
      if (currentJson != null) {
        _currentWeather = WeatherData.fromJson(currentJson);
      }

      // Load forecast
      final forecastList = prefs.getStringList('cached_forecast');
      if (forecastList != null) {
        _forecast = forecastList.map((json) => WeatherData.fromJson(json)).toList();
      }

      // Load city name
      _cityName = prefs.getString('cached_city_name') ?? '';

      // Generate alerts if we loaded cached data
      if (_currentWeather != null) {
        _generateAlerts();
      }
    } catch (_) {
      // Ignore cache errors
    }
  }

  Future<void> _saveToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_currentWeather != null) {
        prefs.setString('cached_current_weather', _currentWeather!.toJson());
      }
      
      if (_forecast.isNotEmpty) {
        final forecastStrings = _forecast.map((w) => w.toJson()).toList();
        prefs.setStringList('cached_forecast', forecastStrings);
      }

      prefs.setString('cached_city_name', _cityName);
    } catch (_) {
      // Ignore cache saving errors
    }
  }

  /// Fetch weather using GPS location.
  /// Automatically requests location permissions and gets coordinates.
  Future<void> fetchWeather({double? lat, double? lon}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get location if not provided
      double? latitude = lat;
      double? longitude = lon;

      if (latitude == null || longitude == null) {
        final position = await _locationService.getCurrentPosition();
        if (position != null) {
          latitude = position.latitude;
          longitude = position.longitude;
        }
      }

      // Fetch current weather
      _currentWeather = await _weatherService.getCurrentWeather(
        lat: latitude,
        lon: longitude,
      );

      // Fetch forecast
      _forecast = await _weatherService.getForecast(
        lat: latitude,
        lon: longitude,
      );

      // Get city name
      if (latitude != null && longitude != null) {
        _cityName = await _weatherService.getCityName(latitude, longitude);
      }

      // Generate alerts based on weather
      _generateAlerts();
      
      // Save to local cache for offline mode
      _saveToCache();
    } catch (e) {
      if (_currentWeather == null) {
        // Only fallback to demo if we have NO cached data
        _currentWeather = WeatherData.demo();
        _forecast = _generateDemoForecast();
        _generateAlerts();
      }
      // If we have cached data, we just keep showing it without overriding with demo
      _error = 'Offline: Showing cached data';
    }

    _isLoading = false;
    notifyListeners();
  }

  void _generateAlerts() {
    if (_currentWeather == null) return;
    _alerts = AlertService.generateAlerts(_currentWeather!, _forecast);
    notifyListeners();
  }

  void markAlertRead(String alertId) {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].markAsRead();
      notifyListeners();
    }
  }

  void dismissAlert(String alertId) {
    _alerts.removeWhere((a) => a.id == alertId);
    notifyListeners();
  }

  List<WeatherData> _generateDemoForecast() {
    return List.generate(7, (i) {
      final day = DateTime.now().add(Duration(days: i + 1));
      return WeatherData(
        temperature: 28 + (i * 1.5) - (i > 3 ? 5 : 0),
        humidity: 60 + (i * 5) - (i > 4 ? 15 : 0),
        windSpeed: 10 + (i * 2),
        rainProbability: i == 2 || i == 5 ? 75 : 20,
        uvIndex: 6 + (i % 3),
        description: i == 2 ? 'Heavy rain' : i == 5 ? 'Thunderstorm' : 'Partly cloudy',
        icon: i == 2 || i == 5 ? '10d' : '02d',
        date: day,
      );
    });
  }
}
