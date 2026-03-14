import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Preview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const WeatherForecastScreen(),
    );
  }
}

class WeatherForecastScreen extends StatelessWidget {
  const WeatherForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.menu, color: Color(0xFF2E7D32)),
              onPressed: () {},
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
                  'San Francisco',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Text(
              'Monday, 12 Aug',
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
                icon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                onPressed: () {},
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Current Weather Icon & Temp
            _buildCurrentWeatherHeader(),
            const SizedBox(height: 30),
            
            // Weather Details Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 2.2,
              children: [
                _buildWeatherDetailCard(Icons.opacity, 'Humidity', '45%', Colors.blue),
                _buildWeatherDetailCard(Icons.air, 'Wind', '12 km/h', Colors.green),
                _buildWeatherDetailCard(Icons.umbrella, 'Rain Prob.', '5%', Colors.indigo),
                _buildWeatherDetailCard(Icons.wb_sunny, 'UV Index', 'High (7)', Colors.orange),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // 7-Day Forecast Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '7-Day Forecast',
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
            
            // Forecast List
            _buildForecastList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCurrentWeatherHeader() {
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
            const Icon(Icons.wb_sunny, size: 100, color: Color(0xFF2E7D32)),
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
        const Text(
          '32°c',
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1B3B32),
          ),
        ),
        const Text(
          'Mostly Sunny',
          style: TextStyle(
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

  Widget _buildForecastList() {
    final List<Map<String, dynamic>> forecast = [
      {'day': 'Tue', 'icon': Icons.wb_sunny, 'high': '34°', 'low': '22°'},
      {'day': 'Wed', 'icon': Icons.cloud, 'high': '29°', 'low': '20°'},
      {'day': 'Thu', 'icon': Icons.grain, 'high': '26°', 'low': '18°'},
      {'day': 'Fri', 'icon': Icons.wb_cloudy, 'high': '28°', 'low': '19°'},
      {'day': 'Sat', 'icon': Icons.wb_sunny, 'high': '31°', 'low': '21°'},
      {'day': 'Sun', 'icon': Icons.wb_sunny, 'high': '33°', 'low': '22°'},
      {'day': 'Mon', 'icon': Icons.wb_sunny, 'high': '35°', 'low': '24°'},
    ];

    return Column(
      children: forecast.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  item['day'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1B3B32),
                  ),
                ),
              ),
              const Spacer(),
              Icon(item['icon'] as IconData, color: const Color(0xFF2E7D32)),
              const Spacer(),
              Text(
                item['high'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1B3B32),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                item['low'],
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

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey[400],
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
