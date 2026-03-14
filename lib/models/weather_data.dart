import 'dart:convert';

class WeatherData {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double rainProbability;
  final double uvIndex;
  final String description;
  final String icon;
  final DateTime date;
  final String cityName;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.rainProbability,
    required this.uvIndex,
    required this.description,
    required this.icon,
    required this.date,
    this.cityName = '',
  });

  factory WeatherData.fromOpenWeatherMap(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final wind = json['wind'] ?? {};
    final weather = (json['weather'] as List?)?.firstOrNull ?? {};
    final rain = json['rain'] ?? {};

    return WeatherData(
      temperature: (main['temp'] ?? 0).toDouble() - 273.15, // Kelvin to Celsius
      humidity: (main['humidity'] ?? 0).toDouble(),
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      rainProbability: (rain['1h'] ?? json['pop'] ?? 0).toDouble() * 100,
      uvIndex: 0, // Requires separate API call
      description: weather['description'] ?? 'Unknown',
      icon: weather['icon'] ?? '01d',
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      cityName: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'rainProbability': rainProbability,
      'uvIndex': uvIndex,
      'description': description,
      'icon': icon,
      'date': date.millisecondsSinceEpoch,
      'cityName': cityName,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      temperature: map['temperature']?.toDouble() ?? 0.0,
      humidity: map['humidity']?.toDouble() ?? 0.0,
      windSpeed: map['windSpeed']?.toDouble() ?? 0.0,
      rainProbability: map['rainProbability']?.toDouble() ?? 0.0,
      uvIndex: map['uvIndex']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      cityName: map['cityName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherData.fromJson(String source) => WeatherData.fromMap(json.decode(source));

  factory WeatherData.demo() {
    return WeatherData(
      temperature: 32.5,
      humidity: 65,
      windSpeed: 12,
      rainProbability: 30,
      uvIndex: 7,
      description: 'Partly cloudy',
      icon: '02d',
      date: DateTime.now(),
      cityName: 'Your Location',
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  bool get isHighHumidity => humidity > 80;
  bool get isHeavyRain => rainProbability > 70;
  bool get isHeatwave => temperature > 42;
  bool get isColdWave => temperature < 4;
  bool get isDangerous => isHighHumidity || isHeavyRain || isHeatwave || isColdWave;
}
