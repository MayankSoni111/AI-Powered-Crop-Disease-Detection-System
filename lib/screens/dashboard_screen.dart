import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/crop_provider.dart';
import '../providers/weather_provider.dart';
import 'disease_scan_screen.dart';
import 'crop_timeline_screen.dart';
import 'weather_screen.dart';
import 'alerts_screen.dart';
import 'help_screen.dart';
import 'crop_setup_screen.dart';
import 'crop_setup_screen.dart';
import 'language_selection_screen.dart';
import 'community_feed_screen.dart';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch weather data on dashboard load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = Provider.of<CropProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final activeCrop = cropProvider.activeCrop;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('dashboard')),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Change Language',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Crop',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CropSetupScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('welcome'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (activeCrop != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '🌱 ${activeCrop.cropName}  •  ${context.tr('day')} ${activeCrop.daysSincePlanting}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Weather summary
            if (weatherProvider.currentWeather != null)
              _WeatherSummaryCard(weather: weatherProvider.currentWeather!),
            const SizedBox(height: 20),

            // Main action grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.1,
              children: [
                _DashboardCard(
                  icon: Icons.document_scanner,
                  title: context.tr('scan_disease'),
                  color: const Color(0xFFE53935),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DiseaseScanScreen())),
                ),
                _DashboardCard(
                  icon: Icons.timeline,
                  title: context.tr('crop_tracker'),
                  color: const Color(0xFF43A047),
                  onTap: () {
                    if (cropProvider.hasCrops) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CropTimelineScreen()));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CropSetupScreen()));
                    }
                  },
                ),
                _DashboardCard(
                  icon: Icons.cloud,
                  title: context.tr('weather'),
                  color: const Color(0xFF1E88E5),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const WeatherScreen())),
                ),
                _DashboardCard(
                  icon: Icons.warning_amber_rounded,
                  title: context.tr('alerts'),
                  color: const Color(0xFFF9A825),
                  badge: weatherProvider.unreadAlertCount,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AlertsScreen())),
                ),
                _DashboardCard(
                  icon: Icons.people_alt,
                  title: 'Community',
                  color: const Color(0xFF8E24AA), // Purple color
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CommunityFeedScreen())),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Help button — full width
            SizedBox(
              width: double.infinity,
              child: _DashboardCard(
                icon: Icons.help_outline,
                title: context.tr('help'),
                color: const Color(0xFF7B1FA2),
                isWide: true,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HelpScreen())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherSummaryCard extends StatelessWidget {
  final dynamic weather;
  const _WeatherSummaryCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF90CAF9)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny, color: Color(0xFFFFA726), size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('todays_weather'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C  •  ${weather.humidity.toStringAsFixed(0)}% ${context.tr('humidity')}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.water_drop, color: Color(0xFF42A5F5), size: 20),
              Text(
                '${weather.rainProbability.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final int badge;
  final bool isWide;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.badge = 0,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isWide ? 20 : 16),
          child: isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      radius: 24,
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundColor: color.withOpacity(0.1),
                          radius: 28,
                          child: Icon(icon, color: color, size: 32),
                        ),
                        if (badge > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$badge',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
