import 'package:city_voice_app/models/report.dart';

/// Draft Report Model
/// Stores partial or complete report data for later editing or submission.
/// Supports conversion to/from Report for seamless workflow.
class DraftReport {
  final String id;
  final String? title;
  final String? description;
  final String? category;
  final String? location;
  final DateTime createdAt;
  final DateTime lastModifiedAt;

  DraftReport({
    required this.id,
    this.title,
    this.description,
    this.category,
    this.location,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  /// Create a DraftReport from a Report
  factory DraftReport.fromReport(Report report) {
    return DraftReport(
      id: report.id,
      title: report.title,
      description: report.description,
      category: report.category,
      location: report.location,
      createdAt: report.createdAt,
      lastModifiedAt: DateTime.now(),
    );
  }

  /// Check if draft has any content
  bool get hasContent =>
      (title?.isNotEmpty ?? false) ||
      (description?.isNotEmpty ?? false) ||
      (category?.isNotEmpty ?? false) ||
      (location?.isNotEmpty ?? false);

  /// Get completion percentage
  int get completionPercentage {
    int filled = 0;
    int total = 4; // title, description, category, location

    if (title?.isNotEmpty ?? false) filled++;
    if (description?.isNotEmpty ?? false) filled++;
    if (category?.isNotEmpty ?? false) filled++;
    if (location?.isNotEmpty ?? false) filled++;

    return ((filled / total) * 100).toInt();
  }

  /// Convert DraftReport to JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'createdAt': createdAt.toIso8601String(),
        'lastModifiedAt': lastModifiedAt.toIso8601String(),
      };

  /// Create DraftReport from JSON
  factory DraftReport.fromJson(Map<String, dynamic> json) {
    return DraftReport(
      id: json['id'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModifiedAt: DateTime.parse(json['lastModifiedAt'] as String),
    );
  }

  /// Create a copy with modifications
  DraftReport copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? location,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  }) {
    return DraftReport(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftReport &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
