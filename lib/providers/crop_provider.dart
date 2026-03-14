import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/crop_cycle.dart';
import 'package:uuid/uuid.dart';

class CropProvider extends ChangeNotifier {
  final List<CropCycle> _cropCycles = [];
  CropCycle? _activeCrop;
  final _uuid = const Uuid();

  CropProvider() {
    _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cropListJson = prefs.getStringList('cached_crop_cycles');
      
      if (cropListJson != null && cropListJson.isNotEmpty) {
        _cropCycles.clear();
        _cropCycles.addAll(cropListJson.map((json) => CropCycle.fromJson(json)));
        
        // Restore active crop
        final activeId = prefs.getString('cached_active_crop_id');
        if (activeId != null) {
          _activeCrop = _cropCycles.firstWhere(
            (c) => c.id == activeId,
            orElse: () => _cropCycles.first,
          );
        } else {
          _activeCrop = _cropCycles.first;
        }
        notifyListeners();
      }
    } catch (_) {
      // Ignore cache errors
    }
  }

  Future<void> _saveToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cropListJson = _cropCycles.map((c) => c.toJson()).toList();
      await prefs.setStringList('cached_crop_cycles', cropListJson);
      
      if (_activeCrop != null) {
        await prefs.setString('cached_active_crop_id', _activeCrop!.id);
      }
    } catch (_) {
      // Ignore cache saving errors
    }
  }

  List<CropCycle> get cropCycles => List.unmodifiable(_cropCycles);
  CropCycle? get activeCrop => _activeCrop;
  bool get hasCrops => _cropCycles.isNotEmpty;

  void addCropCycle({
    required String cropName,
    required String soilType,
    required String wateringFrequency,
    required DateTime plantingDate,
  }) {
    final plantingActivity = FarmingActivity(
      id: _uuid.v4(),
      type: 'planting',
      date: plantingDate,
      notes: 'Crop planted: $cropName',
    );

    final cycle = CropCycle(
      id: _uuid.v4(),
      userId: 'demo_user',
      cropName: cropName,
      soilType: soilType,
      wateringFrequency: wateringFrequency,
      plantingDate: plantingDate,
      activities: [plantingActivity],
    );
    _cropCycles.add(cycle);
    _activeCrop = cycle;
    _saveToCache();
    notifyListeners();
  }

  void addActivity({
    required String cropId,
    required String type,
    String? notes,
  }) {
    final index = _cropCycles.indexWhere((c) => c.id == cropId);
    if (index == -1) return;

    final activity = FarmingActivity(
      id: _uuid.v4(),
      type: type,
      date: DateTime.now(),
      notes: notes,
    );

    final updatedActivities = [..._cropCycles[index].activities, activity];
    
    final updatedCycle = _cropCycles[index].copyWith(
      activities: updatedActivities,
      status: type == 'harvest' ? 'harvested' : null,
      harvestDate: type == 'harvest' ? DateTime.now() : null,
    );

    _cropCycles[index] = updatedCycle;
    if (_activeCrop?.id == cropId) {
      _activeCrop = updatedCycle;
    }
    _saveToCache();
    notifyListeners();
  }

  void setActiveCrop(String cropId) {
    _activeCrop = _cropCycles.firstWhere(
      (c) => c.id == cropId,
      orElse: () => _cropCycles.first,
    );
    _saveToCache();
    notifyListeners();
  }

  List<FarmingActivity> getActivitiesSorted(String cropId) {
    final crop = _cropCycles.firstWhere(
      (c) => c.id == cropId,
      orElse: () => _cropCycles.first,
    );
    final sorted = List<FarmingActivity>.from(crop.activities);
    sorted.sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }
}
