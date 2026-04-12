import 'package:hive/hive.dart';
import 'package:city_voice_app/models/report.dart';

// Service class for handling CRUD operations on reports using Hive.
// Provides methods to get, add, update, and delete reports from local storage.
class ReportService {
  static const String boxName = 'reports_v4';

  Future<Box<Report>> get _box async => await Hive.openBox<Report>(boxName);

  Future<List<Report>> getReports() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> addReport(Report report) async {
    final box = await _box;
    await box.put(report.id, report);
  }

  Future<void> updateReport(Report report) async {
    final box = await _box;
    await box.put(report.id, report);
  }

  Future<void> deleteReport(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}