import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_voice_app/models/draft_report.dart';

/// Service for managing draft reports using SharedPreferences.
/// Handles persistence of draft data locally on the device.
/// Can be easily extended to use Hive or other storage backends.
class DraftService {
  static const String _draftsKey = 'draft_reports';

  late SharedPreferences _prefs;
  bool _initialized = false;

  /// Initialize the service (call once at app startup)
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  /// Ensure service is initialized
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('DraftService not initialized. Call init() first.');
    }
  }

  /// Save or update a draft
  Future<void> saveDraft(DraftReport draft) async {
    _ensureInitialized();
    final drafts = await getDrafts();

    // Remove old draft with same ID if exists
    drafts.removeWhere((d) => d.id == draft.id);

    // Add updated draft
    drafts.add(draft);

    // Persist to storage
    await _persistDrafts(drafts);
  }

  /// Get all saved drafts
  Future<List<DraftReport>> getDrafts() async {
    _ensureInitialized();
    final draftsJson = _prefs.getStringList(_draftsKey) ?? [];

    return draftsJson
        .map((json) => DraftReport.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.lastModifiedAt.compareTo(a.lastModifiedAt));
  }

  /// Get a specific draft by ID
  Future<DraftReport?> getDraft(String id) async {
    _ensureInitialized();
    final drafts = await getDrafts();
    try {
      return drafts.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Delete a draft
  Future<void> deleteDraft(String id) async {
    _ensureInitialized();
    final drafts = await getDrafts();
    drafts.removeWhere((d) => d.id == id);
    await _persistDrafts(drafts);
  }

  /// Delete multiple drafts
  Future<void> deleteDrafts(List<String> ids) async {
    _ensureInitialized();
    final drafts = await getDrafts();
    drafts.removeWhere((d) => ids.contains(d.id));
    await _persistDrafts(drafts);
  }

  /// Clear all drafts
  Future<void> clearAllDrafts() async {
    _ensureInitialized();
    await _prefs.remove(_draftsKey);
  }

  /// Get count of saved drafts
  Future<int> getDraftCount() async {
    _ensureInitialized();
    return (await getDrafts()).length;
  }

  /// Persist drafts list to storage
  Future<void> _persistDrafts(List<DraftReport> drafts) async {
    final draftsJson =
        drafts.map((d) => jsonEncode(d.toJson())).toList();
    await _prefs.setStringList(_draftsKey, draftsJson);
  }
}
