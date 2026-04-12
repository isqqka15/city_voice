import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:city_voice_app/providers/auth_provider.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';

/// Support screen with contact form for users to send messages and support requests.
/// Includes animations, form validation, optional attachment support, and localization.
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedCategory;
  String? _userName;
  String? _userEmail;
  String? _attachedImagePath;
  bool _isSending = false;

  final List<String> _categories = [
    'supportCategoryBug',
    'supportCategoryFeature',
    'supportCategoryQuestion',
    'supportCategoryOther',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = context.read<AuthProvider>();
    setState(() {
      _userEmail = authProvider.currentUser?.email ?? '';
      _userName = authProvider.currentUser?.name ?? '';
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final status = await Permission.photos.request();
      if (status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.locationPermissionDenied),
            ),
          );
        }
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _attachedImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Error selecting image')),
        );
      }
    }
  }

  Future<void> _takeScreenshot() async {
    try {
      final status = await Permission.camera.request();
      if (status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.locationPermissionDenied),
            ),
          );
        }
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _attachedImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Error taking screenshot')),
        );
      }
    }
  }

  void _showMediaOptions() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.fromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.fromCamera),
              onTap: () {
                Navigator.pop(context);
                _takeScreenshot();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectCategory)),
      );
      return;
    }

    setState(() => _isSending = true);

    // Simulate sending message with animation
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() => _isSending = false);

      // Show success animation
      _showSuccessConfirmation();

      // Reset form
      _messageController.clear();
      setState(() {
        _selectedCategory = null;
        _attachedImagePath = null;
      });
    }
  }

  void _showSuccessConfirmation() {
    final l10n = AppLocalizations.of(context)!;
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.3,
        left: 32,
        right: 32,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _animationController.value,
              child: Opacity(
                opacity: _animationController.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.messageSentSuccessfully,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2)).then((_) {
      entry.remove();
    });
  }

  String _getCategoryLabel(String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'supportCategoryBug':
        return l10n.supportCategoryBug;
      case 'supportCategoryFeature':
        return l10n.supportCategoryFeature;
      case 'supportCategoryQuestion':
        return l10n.supportCategoryQuestion;
      case 'supportCategoryOther':
        return l10n.supportCategoryOther;
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Minimalist header
                  Text(
                    l10n.contactUs,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.supportMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Name field (read-only, auto-filled)
                  _buildFormField(
                    label: l10n.supportNameAutoFilled,
                    icon: Icons.person_outline,
                    value: _userName ?? '',
                    readOnly: true,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Email field (read-only, auto-filled)
                  _buildFormField(
                    label: l10n.supportEmailAutoFilled,
                    icon: Icons.mail_outline,
                    value: _userEmail ?? '',
                    readOnly: true,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Category dropdown
                  _buildCategoryDropdown(l10n, theme),
                  const SizedBox(height: 16),

                  // Message field
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: l10n.supportMessage,
                      hintText: l10n.supportMessage,
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    minLines: 4,
                    maxLines: 6,
                    maxLength: 500,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.messageRequired;
                      }
                      if (value.length < 10) {
                        return 'Message must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Attachment section - minimalistic
                  _buildAttachmentSection(l10n, theme),
                  const SizedBox(height: 28),

                  // Send button
                  AnimatedBuilder(
                    animation: _isSending ? _animationController : AlwaysStoppedAnimation(1.0),
                    builder: (context, child) {
                      return ElevatedButton(
                        onPressed: _isSending ? null : _sendMessage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: theme.colorScheme.primary,
                          disabledBackgroundColor: theme.colorScheme.primary.withAlpha(100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSending
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                            : Text(
                          l10n.sendMessage,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    required String value,
    required bool readOnly,
    required ThemeData theme,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    );
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n, ThemeData theme) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      decoration: InputDecoration(
        labelText: l10n.supportCategory,
        prefixIcon: Icon(Icons.category_outlined, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      items: _categories
          .map((category) => DropdownMenuItem(
            value: category,
            child: Text(_getCategoryLabel(category)),
          ))
          .toList(),
      onChanged: (value) {
        setState(() => _selectedCategory = value);
      },
      validator: (value) {
        if (value == null) {
          return l10n.selectCategory;
        }
        return null;
      },
    );
  }

  Widget _buildAttachmentSection(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(128),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_file_outlined,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.supportAttachment,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_attachedImagePath != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_attachedImagePath!),
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _attachedImagePath = null);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.close,
                        color: theme.colorScheme.onError,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            OutlinedButton.icon(
              onPressed: _showMediaOptions,
              icon: Icon(Icons.image_outlined, size: 18),
              label: Text(l10n.supportAttachScreenshot),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: theme.colorScheme.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
