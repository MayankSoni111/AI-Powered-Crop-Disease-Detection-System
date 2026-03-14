class FarmAlert {
  final String id;
  final String title;
  final String description;
  final String severity; // 'info', 'warning', 'danger'
  final DateTime createdAt;
  final bool isRead;
  final String? relatedCropId;

  FarmAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.createdAt,
    this.isRead = false,
    this.relatedCropId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'relatedCropId': relatedCropId,
    };
  }

  factory FarmAlert.fromMap(Map<String, dynamic> map) {
    return FarmAlert(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      severity: map['severity'] ?? 'info',
      createdAt: DateTime.parse(map['createdAt']),
      isRead: map['isRead'] ?? false,
      relatedCropId: map['relatedCropId'],
    );
  }

  FarmAlert markAsRead() {
    return FarmAlert(
      id: id,
      title: title,
      description: description,
      severity: severity,
      createdAt: createdAt,
      isRead: true,
      relatedCropId: relatedCropId,
    );
  }
}
