import '../models/weather_data.dart';
import '../models/alert_model.dart';
import 'package:uuid/uuid.dart';

class AlertService {
  static const _uuid = Uuid();

  /// Generates farming alerts based on current weather and forecast data.
  /// Implements Features 6 and 8 — Smart Farming Alerts & Weather Disaster Risk.
  static List<FarmAlert> generateAlerts(
    WeatherData current,
    List<WeatherData> forecast,
  ) {
    final alerts = <FarmAlert>[];

    // Current weather alerts
    if (current.isHighHumidity) {
      alerts.add(FarmAlert(
        id: _uuid.v4(),
        title: '🍄 Fungal Disease Risk',
        description:
            'Humidity is at ${current.humidity.toStringAsFixed(0)}%. High humidity increases the risk of fungal infections like leaf blight. Monitor your crops closely and avoid excess watering.',
        severity: 'warning',
        createdAt: DateTime.now(),
      ));
    }

    if (current.isHeavyRain) {
      alerts.add(FarmAlert(
        id: _uuid.v4(),
        title: '🌧️ Heavy Rain — Root Rot Risk',
        description:
            'Heavy rainfall detected (${current.rainProbability.toStringAsFixed(0)}% chance). Risk of root rot and waterlogging. Ensure proper drainage and avoid pesticide spraying today.',
        severity: 'danger',
        createdAt: DateTime.now(),
      ));
    }

    if (current.isHeatwave) {
      alerts.add(FarmAlert(
        id: _uuid.v4(),
        title: '🔥 Heatwave — Irrigate Now',
        description:
            'Temperature is ${current.temperature.toStringAsFixed(1)}°C. Extreme heat causes crop stress. Increase irrigation frequency and consider shade nets.',
        severity: 'danger',
        createdAt: DateTime.now(),
      ));
    }

    if (current.isColdWave) {
      alerts.add(FarmAlert(
        id: _uuid.v4(),
        title: '❄️ Cold Wave — Frost Damage Risk',
        description:
            'Temperature dropped to ${current.temperature.toStringAsFixed(1)}°C. Risk of frost damage to your crops. Cover tender plants and avoid watering in the evening.',
        severity: 'danger',
        createdAt: DateTime.now(),
      ));
    }

    // Forecast-based alerts
    for (var day in forecast) {
      if (day.isHeavyRain) {
        final dayName = _getDayName(day.date);
        alerts.add(FarmAlert(
          id: _uuid.v4(),
          title: '⚠️ Rain Expected on $dayName',
          description:
              'Heavy rainfall predicted on $dayName. Avoid pesticide spraying. Prepare drainage channels. Risk of fungal infection increases.',
          severity: 'warning',
          createdAt: DateTime.now(),
        ));
        break; // Only one forecast rain alert
      }
    }

    // UV alert
    if (current.uvIndex >= 8) {
      alerts.add(FarmAlert(
        id: _uuid.v4(),
        title: '☀️ High UV — Protect Yourself',
        description:
            'UV index is ${current.uvIndex.toStringAsFixed(0)}. Use protective clothing and sunscreen while working in the field.',
        severity: 'info',
        createdAt: DateTime.now(),
      ));
    }

    // Pest season alert (simulate seasonal detection)
    final month = DateTime.now().month;
    if (month >= 6 && month <= 9) {
      alerts.add(FarmAlert(
        id: _uuid.v4(),
        title: '🐛 Pest Season Alert',
        description:
            'Monsoon season is peak time for pest infestations. Inspect your crops regularly and look for signs of insect damage.',
        severity: 'info',
        createdAt: DateTime.now(),
      ));
    }

    return alerts;
  }

  static String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
