import 'package:flutter/material.dart';

class Categories {
  static const lighting = 'lighting';
  static const garbage = 'garbage';
  static const roads = 'roads';
  static const waterSewage = 'waterSewage';
  static const publicSafety = 'publicSafety';
  static const other = 'other';
  static const all = [lighting, garbage, roads, waterSewage, publicSafety, other];
}

class Statuses {
  static const notReviewed = 'not_reviewed';
  static const underReview = 'under_review';
  static const approved = 'approved';
  static const rejected = 'rejected';
}

class StatusColors {
  static Color notReviewed(BuildContext context) => Theme.of(context).colorScheme.outlineVariant;
  static Color underReview(BuildContext context) => Theme.of(context).colorScheme.primary;
  static Color approved(BuildContext context) => Colors.green;
  static Color rejected(BuildContext context) => Theme.of(context).colorScheme.error;
}

class CategoryColors {
  static const lighting = Color(0xFFFF9800); // orange
  static const garbage = Color(0xFF4CAF50); // green
  static const roads = Color(0xFF2196F3); // blue
  static const waterSewage = Color(0xFF00BCD4); // cyan
  static const publicSafety = Color(0xFF9C27B0); // purple
  static const other = Color(0xFF9E9E9E); // grey
}
