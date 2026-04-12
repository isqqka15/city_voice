import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 'intl' removed: DateFormat is no longer used in this file
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:city_voice_app/models/report.dart';
import 'package:city_voice_app/models/draft_report.dart';
import 'package:city_voice_app/providers/report_provider.dart';
import 'package:city_voice_app/providers/draft_provider.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/widgets/primary_button.dart';
import 'package:city_voice_app/utils/constants.dart';
import 'package:city_voice_app/widgets/action_button.dart';

// Screen for adding or editing a report.
// Handles both create and edit modes based on the provided report.
// Supports loading from and saving to draft reports.
// Uses form validation, date picker, and scrollable layout.
class ReportFormScreen extends StatefulWidget {
  final Report? report;
  final DraftReport? draft;

  const ReportFormScreen({super.key, this.report, this.draft});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _selectedCategory;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  List<String> _attachedMedia = [];
  late String _draftId;
  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();
    // Generate draft ID on creation
    _draftId = widget.draft?.id ?? widget.report?.id ?? DateTime.now().toString();
    
    // Initialize controllers with existing data if editing a report or loading a draft
    _titleController = TextEditingController(text: widget.report?.title ?? widget.draft?.title ?? '');
    _descriptionController = TextEditingController(text: widget.report?.description ?? widget.draft?.description ?? '');
    _selectedCategory = widget.report?.category ?? widget.draft?.category ?? '';
    _selectedDate = widget.report?.createdAt ?? DateTime.now();
    _locationController = TextEditingController(text: widget.report?.location ?? widget.draft?.location ?? '');
    _attachedMedia = List.from(widget.report?.attachedMedia ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _attachEvidence() async {
    final ImagePicker picker = ImagePicker();
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.attachEvidence),
          content: Text(localizations.chooseMedia),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.fromGallery),
              onPressed: () async {
                Navigator.of(context).pop();
                final List<XFile> medias = await picker.pickMultiImage();
                setState(() {
                  _attachedMedia.addAll(medias.map((m) => m.path));
                });
              },
            ),
            TextButton(
              child: Text(localizations.fromCamera),
              onPressed: () async {
                Navigator.of(context).pop();
                final XFile? media = await picker.pickImage(source: ImageSource.camera);
                if (media != null) {
                  setState(() {
                    _attachedMedia.add(media.path);
                  });
                }
              },
            ),
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectLocation() async {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.selectLocation),
          content: Text(localizations.chooseLocation),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.manualEntry),
              onPressed: () async {
                Navigator.of(context).pop();
                final result = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    final controller = TextEditingController(text: _locationController.text);
                    return AlertDialog(
                      title: Text(localizations.enterLocation),
                      content: TextField(
                        controller: controller,
                        decoration: InputDecoration(hintText: localizations.typeYourLocation),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(localizations.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(controller.text),
                          child: Text(localizations.ok),
                        ),
                      ],
                    );
                  },
                );
                if (result != null) {
                  setState(() {
                    _locationController.text = result;
                  });
                }
              },
            ),
            TextButton(
              child: Text(localizations.autoDetect),
              onPressed: () async {
                Navigator.of(context).pop();
                final currentContext = context;
                final messenger = ScaffoldMessenger.of(currentContext);
                try {
                  final permission = await Permission.location.request();
                  if (permission.isGranted) {
                    final position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                    setState(() {
                      _locationController.text = '${position.latitude}, ${position.longitude}';
                    });
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(localizations.locationPermissionDenied),
                      ),
                    );
                  }
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(localizations.unableToGetLocation),
                    ),
                  );
                }
              },
            ),
            TextButton(
              child: Text(localizations.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _saveDraft() {
    if (_titleController.text.isEmpty && 
        _descriptionController.text.isEmpty && 
        _selectedCategory == '' && 
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.draftSavedSuccessfully),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
      return;
    }

    setState(() => _isSavingDraft = true);

    final draft = DraftReport(
      id: _draftId,
      title: _titleController.text.isEmpty ? null : _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      category: _selectedCategory?.isEmpty ?? true ? null : _selectedCategory,
      location: _locationController.text.isEmpty ? null : _locationController.text,
      createdAt: widget.draft?.createdAt ?? DateTime.now(),
      lastModifiedAt: DateTime.now(),
    );

    final draftProvider = context.read<DraftProvider>();
    
    final Future<void> saveFuture = widget.draft != null
      ? draftProvider.updateDraft(draft)
      : draftProvider.saveDraft(draft);

    saveFuture.then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.draftSavedSuccessfully),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
      setState(() => _isSavingDraft = false);
    }).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.errorSavingDraft}: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() => _isSavingDraft = false);
      }
    });
  }

  void _submitDraft() {
    if (_formKey.currentState!.validate()) {
      final report = Report(
        id: _draftId,
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory ?? '',
        createdAt: _selectedDate,
        attachedMedia: _attachedMedia,
        location: _locationController.text.isEmpty ? null : _locationController.text,
      );
      
      final reportProvider = context.read<ReportProvider>();
      final draftProvider = context.read<DraftProvider>();
      
      reportProvider.addReport(report);
      
      // Delete the draft after successful submission
      if (widget.draft != null) {
        draftProvider.deleteDraft(widget.draft!.id).then((_) {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _showSaveMenu(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.save_outlined),
                title: Text(localizations.saveDraft),
                onTap: () {
                  Navigator.pop(ctx);
                  _saveDraft();
                },
              ),
              ListTile(
                leading: const Icon(Icons.send_outlined),
                title: Text(localizations.submitDraft),
                onTap: () {
                  Navigator.pop(ctx);
                  _submitDraft();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _discardDraft() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.discardDraft),
          content: Text(localizations.discardDraftConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (widget.draft != null) {
                  final draftProvider = context.read<DraftProvider>();
                  draftProvider.deleteDraft(widget.draft!.id).then((_) {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(localizations.discardDraft),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isEditingReport = widget.report != null;
    final isEditingDraft = widget.draft != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditingReport 
            ? localizations.editReport 
            : isEditingDraft 
              ? localizations.editingDraft 
              : localizations.addReport
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: localizations.title,
                  hintText: localizations.title,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${localizations.title} is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: localizations.description,
                  hintText: localizations.description,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: (_selectedCategory?.isEmpty ?? true) || !Categories.all.contains(_selectedCategory) ? null : _selectedCategory,
                decoration: InputDecoration(
                  labelText: localizations.category,
                  hintText: localizations.category,
                ),
                items: Categories.all.map((cat) {
                  String display;
                  switch (cat) {
                    case Categories.lighting:
                      display = localizations.categoryLighting;
                      break;
                    case Categories.garbage:
                      display = localizations.categoryGarbage;
                      break;
                    case Categories.roads:
                      display = localizations.categoryRoads;
                      break;
                    case Categories.waterSewage:
                      display = localizations.categoryWaterSewage;
                      break;
                    case Categories.publicSafety:
                      display = localizations.categoryPublicSafety;
                      break;
                    case Categories.other:
                      display = localizations.categoryOther;
                      break;
                    default:
                      display = cat;
                  }
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(display),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${localizations.category} is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: localizations.selectLocation,
                onPressed: _selectLocation,
                icon: Icons.location_on_outlined,
                width: double.infinity,
              ),
              if (_locationController.text.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Location: ${_locationController.text}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              ActionButton(
                text: localizations.selectDate,
                onPressed: () => _selectDate(context),
                icon: Icons.calendar_today_outlined,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              ActionButton(
                text: localizations.attachEvidence,
                onPressed: _attachEvidence,
                icon: Icons.image_outlined,
                width: double.infinity,
              ),
              if (_attachedMedia.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Attached Media:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _attachedMedia.map((path) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                        image: path.endsWith('.mp4') || path.endsWith('.mov') || path.endsWith('.avi')
                            ? null
                            : DecorationImage(
                                image: FileImage(File(path)),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: path.endsWith('.mp4') || path.endsWith('.mov') || path.endsWith('.avi')
                          ? const Icon(Icons.videocam, color: Colors.white)
                          : null,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              // Single Save button - opens modal to choose Save as Draft or Submit as Report
              PrimaryButton(
                text: localizations.saveReport,
                onPressed: _isSavingDraft ? () {} : () => _showSaveMenu(context),
                icon: Icons.save_outlined,
              ),
              const SizedBox(height: 12),
              if (isEditingDraft)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isSavingDraft ? () {} : _discardDraft,
                    child: Text(localizations.discardDraft),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}