import 'package:hive/hive.dart';

part 'report.g.dart';

// Data model for a city issue report.
// Uses Hive annotations for local storage serialization.
// Fields: id, title, description, category, createdAt, attachedMedia.
@HiveType(typeId: 0)
class Report extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final List<String> attachedMedia;

  @HiveField(6)
  final String? location;

  @HiveField(7)
  String status;

  @HiveField(8)
  DateTime updatedAt;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    this.attachedMedia = const [],
    this.location,
    this.status = 'not_reviewed',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;
}