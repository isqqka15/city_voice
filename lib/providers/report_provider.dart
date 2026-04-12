import 'package:flutter/material.dart';
import 'package:city_voice_app/models/report.dart';
import 'package:city_voice_app/services/report_service.dart';

// Provider for managing the state of reports.
// Uses ChangeNotifier to notify listeners when data changes.
// Handles loading, adding, updating, and deleting reports.
class ReportProvider with ChangeNotifier {
  final ReportService _service = ReportService();

  List<Report> _reports = [];

  List<Report> get reports => _reports;

  Future<void> loadReports() async {
    _reports = await _service.getReports();
    _simulateStatusProgression();
    notifyListeners();
  }

  void _simulateStatusProgression() {
    // Status progression is now managed by backend/admin, not automatically
    // Reports maintain their assigned status until explicitly changed
  }

  Future<void> addReport(Report report) async {
    await _service.addReport(report);
    await loadReports();
  }

  Future<void> updateReport(Report report) async {
    await _service.updateReport(report);
    await loadReports();
  }

  Future<void> deleteReport(String id) async {
    await _service.deleteReport(id);
    await loadReports();
  }
}