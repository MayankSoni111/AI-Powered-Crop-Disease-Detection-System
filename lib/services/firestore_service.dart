import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/crop_cycle.dart';
import '../models/alert_model.dart';

/// Firestore database service for storing and retrieving user data.
/// 
/// Database Schema:
/// ```
/// users/{userId}/
///   - name, phone, language, location, createdAt
/// 
/// users/{userId}/cropCycles/{cycleId}/
///   - cropName, soilType, wateringFrequency, plantingDate, harvestDate, status
///
/// users/{userId}/cropCycles/{cycleId}/activities/{activityId}/
///   - type, date, notes
///
/// users/{userId}/alerts/{alertId}/
///   - title, description, severity, isRead, createdAt
///
/// users/{userId}/diseaseDetections/{detectionId}/
///   - cropCycleId, imagePath, diseaseName, confidence, treatment, detectedAt
/// ```
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Users ────────────────────────────────────────────────
  Future<void> createUser({
    required String userId,
    required String name,
    required String phone,
    required String language,
  }) async {
    await _db.collection('users').doc(userId).set({
      'name': name,
      'phone': phone,
      'language': language,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserLanguage(String userId, String language) async {
    await _db.collection('users').doc(userId).update({
      'language': language,
    });
  }

  // ─── Crop Cycles ──────────────────────────────────────────
  Future<void> saveCropCycle(CropCycle cycle) async {
    await _db
        .collection('users')
        .doc(cycle.userId)
        .collection('cropCycles')
        .doc(cycle.id)
        .set(cycle.toMap());

    // Save activities as subcollection
    for (var activity in cycle.activities) {
      await _db
          .collection('users')
          .doc(cycle.userId)
          .collection('cropCycles')
          .doc(cycle.id)
          .collection('activities')
          .doc(activity.id)
          .set(activity.toMap());
    }
  }

  Future<List<CropCycle>> getCropCycles(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('cropCycles')
        .orderBy('plantingDate', descending: true)
        .get();

    final cycles = <CropCycle>[];
    for (var doc in snapshot.docs) {
      // Fetch activities for each cycle
      final activitiesSnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('cropCycles')
          .doc(doc.id)
          .collection('activities')
          .orderBy('date')
          .get();

      final activities = activitiesSnapshot.docs
          .map((a) => FarmingActivity.fromMap(a.data()))
          .toList();

      cycles.add(CropCycle.fromMap(doc.data(), activities: activities));
    }
    return cycles;
  }

  Future<void> addActivity(String userId, String cropId, FarmingActivity activity) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('cropCycles')
        .doc(cropId)
        .collection('activities')
        .doc(activity.id)
        .set(activity.toMap());
  }

  // ─── Alerts ───────────────────────────────────────────────
  Future<void> saveAlert(String userId, FarmAlert alert) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('alerts')
        .doc(alert.id)
        .set(alert.toMap());
  }

  Future<List<FarmAlert>> getAlerts(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('alerts')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => FarmAlert.fromMap(doc.data())).toList();
  }

  // ─── Disease Detections ───────────────────────────────────
  Future<void> saveDiseaseDetection({
    required String userId,
    required String cropCycleId,
    required String diseaseName,
    required double confidence,
    required String treatment,
    String? imagePath,
  }) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('diseaseDetections')
        .add({
      'cropCycleId': cropCycleId,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'treatment': treatment,
      'imagePath': imagePath,
      'detectedAt': FieldValue.serverTimestamp(),
    });
  }
}
