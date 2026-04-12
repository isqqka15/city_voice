import 'package:flutter/foundation.dart';
import 'package:city_voice_app/models/report.dart';
import 'package:city_voice_app/utils/constants.dart';

enum Category { lighting, garbage, roads, waterSewage, publicSafety, other }

enum FilterStatus { notReviewed, underReview, approved, rejected }

enum DateSort { newestFirst, oldestFirst }

class ReportFilterProvider with ChangeNotifier {
  final Set<Category> _categories = {};
  final Set<FilterStatus> _statuses = {};
  DateSort _sort = DateSort.newestFirst;

  Set<Category> get categories => _categories;
  Set<FilterStatus> get statuses => _statuses;
  DateSort get sort => _sort;

  void setFilters({Set<Category>? categories, Set<FilterStatus>? statuses, DateSort? sort}) {
    _categories
      ..clear()
      ..addAll(categories ?? {});
    _statuses
      ..clear()
      ..addAll(statuses ?? {});
    if (sort != null) _sort = sort;
    notifyListeners();
  }

  void clearFilters() {
    _categories.clear();
    _statuses.clear();
    _sort = DateSort.newestFirst;
    notifyListeners();
  }

  List<Report> applyFilters(List<Report> reports) {
    var list = reports;

    // Category filtering
    if (_categories.isNotEmpty) {
      list = list.where((r) => _matchesCategory(r)).toList();
    }

    // Status filtering
    if (_statuses.isNotEmpty) {
      list = list.where((r) => _matchesStatus(r)).toList();
    }

    // Sorting
    list.sort((a, b) => _sort == DateSort.newestFirst
      ? b.createdAt.compareTo(a.createdAt)
      : a.createdAt.compareTo(b.createdAt));

    return list;
  }

  bool _matchesCategory(Report r) {
    return _categories.any((c) => r.category == c.name);
  }

  bool _matchesStatus(Report r) {
    for (final sel in _statuses) {
      switch (sel) {
        case FilterStatus.notReviewed:
          if (r.status == Statuses.notReviewed) return true;
          break;
        case FilterStatus.underReview:
          if (r.status == Statuses.underReview) return true;
          break;
        case FilterStatus.approved:
          if (r.status == Statuses.approved) return true;
          break;
        case FilterStatus.rejected:
          if (r.status == Statuses.rejected) return true;
          break;
      }
    }
    return false;
  }
}
