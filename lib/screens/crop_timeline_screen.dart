import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/crop_provider.dart';
import '../models/crop_cycle.dart';

class CropTimelineScreen extends StatelessWidget {
  const CropTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cropProvider = Provider.of<CropProvider>(context);
    final activeCrop = cropProvider.activeCrop;

    if (activeCrop == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr('crop_timeline'))),
        body: Center(
          child: Text(context.tr('no_activities')),
        ),
      );
    }

    final activities = cropProvider.getActivitiesSorted(activeCrop.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('crop_timeline')),
      ),
      body: Column(
        children: [
          // Crop info header
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.eco, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeCrop.cropName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${context.tr('day')} ${activeCrop.daysSincePlanting} • ${context.tr('soil_${activeCrop.soilType}')}',
                        style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    activeCrop.status == 'harvested' ? '✅ Harvested' : '🌱 Active',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Timeline list
          Expanded(
            child: activities.isEmpty
                ? Center(
                    child: Text(
                      context.tr('no_activities'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return _TimelineTile(
                        activity: activities[index],
                        plantingDate: activeCrop.plantingDate,
                        isFirst: index == 0,
                        isLast: index == activities.length - 1,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: activeCrop.status != 'harvested'
          ? FloatingActionButton.extended(
              onPressed: () => _showAddActivityDialog(context, activeCrop.id),
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: Text(context.tr('add_activity')),
            )
          : null,
    );
  }

  void _showAddActivityDialog(BuildContext context, String cropId) {
    String? selectedType;
    final notesController = TextEditingController();

    final activityTypes = [
      {'type': 'irrigation', 'icon': Icons.water_drop, 'color': Colors.blue},
      {'type': 'fertilizer', 'icon': Icons.science, 'color': Colors.amber},
      {'type': 'pesticide', 'icon': Icons.bug_report, 'color': Colors.red},
      {'type': 'inspection', 'icon': Icons.search, 'color': Colors.purple},
      {'type': 'harvest', 'icon': Icons.agriculture, 'color': Colors.green},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('add_activity'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Activity type selector
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: activityTypes.map((at) {
                      final type = at['type'] as String;
                      final isActive = selectedType == type;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedType = type),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive
                                ? (at['color'] as Color).withOpacity(0.15)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive
                                  ? at['color'] as Color
                                  : Colors.grey.shade300,
                              width: isActive ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(at['icon'] as IconData,
                                  color: at['color'] as Color, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                context.tr(type),
                                style: TextStyle(
                                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      hintText: context.tr('notes_hint'),
                      labelText: context.tr('notes'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  // Add button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: selectedType != null
                          ? () {
                              Provider.of<CropProvider>(context, listen: false)
                                  .addActivity(
                                cropId: cropId,
                                type: selectedType!,
                                notes: notesController.text.isNotEmpty
                                    ? notesController.text
                                    : null,
                              );
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.tr('activity_added')),
                                  backgroundColor: const Color(0xFF2E7D32),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.check),
                      label: Text(context.tr('save')),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final FarmingActivity activity;
  final DateTime plantingDate;
  final bool isFirst;
  final bool isLast;

  const _TimelineTile({
    required this.activity,
    required this.plantingDate,
    required this.isFirst,
    required this.isLast,
  });

  static const _activityConfig = {
    'planting': {'icon': Icons.eco, 'color': Color(0xFF4CAF50)},
    'irrigation': {'icon': Icons.water_drop, 'color': Color(0xFF2196F3)},
    'fertilizer': {'icon': Icons.science, 'color': Color(0xFFFFA726)},
    'pesticide': {'icon': Icons.bug_report, 'color': Color(0xFFE53935)},
    'inspection': {'icon': Icons.search, 'color': Color(0xFF9C27B0)},
    'harvest': {'icon': Icons.agriculture, 'color': Color(0xFF2E7D32)},
  };

  @override
  Widget build(BuildContext context) {
    final config = _activityConfig[activity.type] ??
        {'icon': Icons.circle, 'color': Colors.grey};
    final color = config['color'] as Color;
    final icon = config['icon'] as IconData;
    final dayNum = activity.daysSince(plantingDate);
    final dateStr = DateFormat('dd MMM yyyy').format(activity.date);

    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline line & dot
          SizedBox(
            width: 48,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(child: Container(width: 3, color: color.withOpacity(0.3))),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.4), blurRadius: 6),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 3, color: color.withOpacity(0.3))),
              ],
            ),
          ),
          // Content card
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.15),
                    radius: 20,
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(activity.type),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${context.tr('day')} $dayNum • $dateStr',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (activity.notes != null && activity.notes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            activity.notes!,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
