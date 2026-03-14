import 'dart:convert';

class CropCycle {
  final String id;
  final String userId;
  final String cropName;
  final String soilType;
  final String wateringFrequency;
  final DateTime plantingDate;
  final DateTime? harvestDate;
  final String status; // 'active', 'harvested'
  final List<FarmingActivity> activities;

  CropCycle({
    required this.id,
    required this.userId,
    required this.cropName,
    required this.soilType,
    required this.wateringFrequency,
    required this.plantingDate,
    this.harvestDate,
    this.status = 'active',
    this.activities = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cropName': cropName,
      'soilType': soilType,
      'wateringFrequency': wateringFrequency,
      'plantingDate': plantingDate.toIso8601String(),
      'harvestDate': harvestDate?.toIso8601String(),
      'status': status,
      'activities': activities.map((a) => a.toMap()).toList(),
    };
  }

  factory CropCycle.fromMap(Map<String, dynamic> map, {List<FarmingActivity>? activities}) {
    return CropCycle(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      cropName: map['cropName'] ?? '',
      soilType: map['soilType'] ?? '',
      wateringFrequency: map['wateringFrequency'] ?? '',
      plantingDate: DateTime.parse(map['plantingDate']),
      harvestDate: map['harvestDate'] != null ? DateTime.parse(map['harvestDate']) : null,
      status: map['status'] ?? 'active',
      activities: activities ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CropCycle.fromJson(String source) {
    final map = json.decode(source);
    final activitiesList = (map['activities'] as List?)
            ?.map((a) => FarmingActivity.fromMap(a))
            .toList() ??
        [];
    return CropCycle.fromMap(map, activities: activitiesList);
  }

  CropCycle copyWith({
    String? cropName,
    String? soilType,
    String? wateringFrequency,
    DateTime? plantingDate,
    DateTime? harvestDate,
    String? status,
    List<FarmingActivity>? activities,
  }) {
    return CropCycle(
      id: id,
      userId: userId,
      cropName: cropName ?? this.cropName,
      soilType: soilType ?? this.soilType,
      wateringFrequency: wateringFrequency ?? this.wateringFrequency,
      plantingDate: plantingDate ?? this.plantingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      status: status ?? this.status,
      activities: activities ?? this.activities,
    );
  }

  int get daysSincePlanting => DateTime.now().difference(plantingDate).inDays;
}

class FarmingActivity {
  final String id;
  final String type; // 'irrigation', 'fertilizer', 'pesticide', 'harvest', 'inspection', 'planting'
  final DateTime date;
  final String? notes;

  FarmingActivity({
    required this.id,
    required this.type,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory FarmingActivity.fromMap(Map<String, dynamic> map) {
    return FarmingActivity(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FarmingActivity.fromJson(String source) => FarmingActivity.fromMap(json.decode(source));

  int daysSince(DateTime plantingDate) => date.difference(plantingDate).inDays;
}
