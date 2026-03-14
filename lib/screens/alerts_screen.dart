import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/weather_provider.dart';
import '../models/alert_model.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final alerts = weatherProvider.alerts;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('alerts_title')),
        actions: [
          if (alerts.isNotEmpty)
            TextButton(
              onPressed: () {
                for (var alert in alerts) {
                  weatherProvider.markAlertRead(alert.id);
                }
              },
              child: Text(
                context.tr('mark_read'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: alerts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 80, color: Colors.green.shade300),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('no_alerts'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                return _AlertCard(
                  alert: alerts[index],
                  onDismiss: () =>
                      weatherProvider.dismissAlert(alerts[index].id),
                  onRead: () =>
                      weatherProvider.markAlertRead(alerts[index].id),
                );
              },
            ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final FarmAlert alert;
  final VoidCallback onDismiss;
  final VoidCallback onRead;

  const _AlertCard({
    required this.alert,
    required this.onDismiss,
    required this.onRead,
  });

  Color get _severityColor {
    switch (alert.severity) {
      case 'danger':
        return const Color(0xFFE53935);
      case 'warning':
        return const Color(0xFFFFA726);
      default:
        return const Color(0xFF42A5F5);
    }
  }

  IconData get _severityIcon {
    switch (alert.severity) {
      case 'danger':
        return Icons.error;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alert.id),
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      child: GestureDetector(
        onTap: onRead,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: alert.isRead
                ? Colors.grey.shade50
                : _severityColor.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: alert.isRead
                  ? Colors.grey.shade200
                  : _severityColor.withOpacity(0.3),
            ),
            boxShadow: !alert.isRead
                ? [
                    BoxShadow(
                      color: _severityColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _severityIcon,
                    color: _severityColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: alert.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: _severityColor,
                              ),
                            ),
                          ),
                          if (!alert.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _severityColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alert.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
