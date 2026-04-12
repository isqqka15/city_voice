import 'package:flutter/material.dart';
import 'package:city_voice_app/models/draft_report.dart';
import 'package:city_voice_app/services/draft_service.dart';

/// State management for draft reports
/// Handles loading, saving, updating, and deleting drafts
/// Integrates with DraftService for persistent storage
class DraftProvider extends ChangeNotifier {
  final DraftService _draftService;

  List<DraftReport> _drafts = [];
  bool _isLoading = false;
  String? _savingDraftId;
  String? _lastSavedMessage;

  DraftProvider(this._draftService) {
    // Ensure the underlying service is initialized and then load drafts
    _draftService.init().then((_) => loadDrafts()).catchError((e) {
      debugPrint('DraftService init error: $e');
    });
  }

  // Getters
  List<DraftReport> get drafts => _drafts;
  bool get isLoading => _isLoading;
  bool get hasDrafts => _drafts.isNotEmpty;
  int get draftCount => _drafts.length;
  bool get isSaving => _savingDraftId != null;
  String? get lastSavedMessage => _lastSavedMessage;

  /// Initialize provider - load all drafts
  Future<void> init() async {
    await loadDrafts();
  }

  /// Load all drafts from storage
  Future<void> loadDrafts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _drafts = await _draftService.getDrafts();
    } catch (e) {
      debugPrint('Error loading drafts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Save a new draft
  Future<void> saveDraft(DraftReport draft) async {
    _savingDraftId = draft.id;
    notifyListeners();

    try {
      await _draftService.saveDraft(draft);
      _drafts.removeWhere((d) => d.id == draft.id);
      _drafts.insert(0, draft);

      _lastSavedMessage = 'Draft saved';
      _savingDraftId = null;

      // Clear message after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      _lastSavedMessage = null;

      notifyListeners();
    } catch (e) {
      _savingDraftId = null;
      _lastSavedMessage = 'Failed to save draft';
      debugPrint('Error saving draft: $e');
      notifyListeners();
    }
  }

  /// Update an existing draft
  Future<void> updateDraft(DraftReport draft) async {
    _savingDraftId = draft.id;
    notifyListeners();

    try {
      final updatedDraft = draft.copyWith();
      await _draftService.saveDraft(updatedDraft);

      final index = _drafts.indexWhere((d) => d.id == draft.id);
      if (index != -1) {
        _drafts[index] = updatedDraft;
      }

      _lastSavedMessage = 'Draft updated';
      _savingDraftId = null;

      // Clear message after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      _lastSavedMessage = null;

      notifyListeners();
    } catch (e) {
      _savingDraftId = null;
      _lastSavedMessage = 'Failed to update draft';
      debugPrint('Error updating draft: $e');
      notifyListeners();
    }
  }

  /// Delete a draft
  Future<void> deleteDraft(String draftId) async {
    try {
      await _draftService.deleteDraft(draftId);
      _drafts.removeWhere((d) => d.id == draftId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting draft: $e');
    }
  }

  /// Delete multiple drafts
  Future<void> deleteDrafts(List<String> draftIds) async {
    try {
      await _draftService.deleteDrafts(draftIds);
      _drafts.removeWhere((d) => draftIds.contains(d.id));
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting drafts: $e');
    }
  }

  /// Clear all drafts
  Future<void> clearAllDrafts() async {
    try {
      await _draftService.clearAllDrafts();
      _drafts.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing drafts: $e');
    }
  }

  /// Get a draft by ID
  DraftReport? getDraftById(String id) {
    try {
      return _drafts.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if a draft exists
  bool draftExists(String id) {
    return _drafts.any((d) => d.id == id);
  }
}
