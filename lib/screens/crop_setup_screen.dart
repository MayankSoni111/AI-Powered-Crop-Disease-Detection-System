import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/crop_provider.dart';
import 'dashboard_screen.dart';

class CropSetupScreen extends StatefulWidget {
  const CropSetupScreen({super.key});

  @override
  State<CropSetupScreen> createState() => _CropSetupScreenState();
}

class _CropSetupScreenState extends State<CropSetupScreen> {
  final _cropNameController = TextEditingController();
  String? _selectedSoil;
  String? _selectedWatering;
  DateTime? _plantingDate;

  final List<Map<String, dynamic>> _soilTypes = [
    {'key': 'clay', 'icon': Icons.terrain, 'color': const Color(0xFF8D6E63)},
    {'key': 'sandy', 'icon': Icons.beach_access, 'color': const Color(0xFFFFB74D)},
    {'key': 'loamy', 'icon': Icons.grass, 'color': const Color(0xFF66BB6A)},
    {'key': 'black', 'icon': Icons.landscape, 'color': const Color(0xFF424242)},
    {'key': 'red', 'icon': Icons.filter_hdr, 'color': const Color(0xFFE57373)},
  ];

  final List<String> _wateringOptions = ['daily', '2days', 'weekly'];

  bool get _isFormValid =>
      _cropNameController.text.isNotEmpty &&
      _selectedSoil != null &&
      _selectedWatering != null &&
      _plantingDate != null;

  @override
  void dispose() {
    _cropNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('crop_setup')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco, color: Colors.white, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('crop_setup'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tell us about your crop',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Crop Name
            _SectionTitle(title: context.tr('crop_name')),
            const SizedBox(height: 8),
            TextField(
              controller: _cropNameController,
              decoration: InputDecoration(
                hintText: context.tr('crop_name_hint'),
                prefixIcon: const Icon(Icons.agriculture, color: Color(0xFF2E7D32)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Soil Type
            _SectionTitle(title: context.tr('select_soil')),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _soilTypes.map((soil) {
                final key = soil['key'] as String;
                final isSelected = _selectedSoil == key;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSoil = key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (soil['color'] as Color).withOpacity(0.15)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? soil['color'] as Color : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          soil['icon'] as IconData,
                          color: soil['color'] as Color,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.tr('soil_$key'),
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? soil['color'] as Color : Colors.black87,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.check_circle, color: soil['color'] as Color, size: 18),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Watering Frequency
            _SectionTitle(title: context.tr('select_watering')),
            const SizedBox(height: 12),
            ...['daily', '2days', 'weekly'].map((option) {
              final isSelected = _selectedWatering == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _selectedWatering = option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2E7D32).withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          context.tr('water_$option'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFF2E7D32) : Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Planting Date
            _SectionTitle(title: context.tr('planting_date')),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF2E7D32),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() => _plantingDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 12),
                    Text(
                      _plantingDate != null
                          ? '${_plantingDate!.day}/${_plantingDate!.month}/${_plantingDate!.year}'
                          : context.tr('select_date'),
                      style: TextStyle(
                        fontSize: 16,
                        color: _plantingDate != null ? Colors.black87 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Start Tracking Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isFormValid
                    ? () {
                        final cropProvider =
                            Provider.of<CropProvider>(context, listen: false);
                        cropProvider.addCropCycle(
                          cropName: _cropNameController.text.trim(),
                          soilType: _selectedSoil!,
                          wateringFrequency: _selectedWatering!,
                          plantingDate: _plantingDate!,
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const DashboardScreen(),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.play_arrow, size: 28),
                label: Text(context.tr('start_tracking')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B5E20),
      ),
    );
  }
}
