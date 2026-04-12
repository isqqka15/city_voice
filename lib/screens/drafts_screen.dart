import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:city_voice_app/providers/draft_provider.dart';
import 'package:city_voice_app/models/draft_report.dart';
import 'package:city_voice_app/screens/report_form_screen.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/utils/animated_route.dart';
import 'package:city_voice_app/widgets/category_chip.dart';

/// Screen for viewing and managing saved draft reports.
/// Shows list of all drafts with completion percentage.
/// Users can edit, delete, or submit drafts from here.
class DraftsScreen extends StatefulWidget {
  const DraftsScreen({super.key});

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.drafts),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Consumer<DraftProvider>(
            builder: (context, draftProvider, child) {
              if (draftProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!draftProvider.hasDrafts) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.noDrafts,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
      Text(
                        'Start creating a report and save it as a draft',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                itemCount: draftProvider.drafts.length,
                itemBuilder: (context, index) {
                  final draft = draftProvider.drafts[index];
                  return DraftCard(
                    draft: draft,
                    onEdit: () {
                      Navigator.push(
                        context,
                        FadePageRoute(
                          builder: (_) => ReportFormScreen(draft: draft),
                        ),
                      );
                    },
                    onDelete: () {
                      _showDeleteConfirmation(
                        context,
                        draft,
                        draftProvider,
                        localizations,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    DraftReport draft,
    DraftProvider draftProvider,
    AppLocalizations localizations,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localizations.deleteDraft),
        content: Text(localizations.thisActionCannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              draftProvider.deleteDraft(draft.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.draftDeleted)),
              );
            },
            child: Text(
              localizations.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual draft card widget
class DraftCard extends StatefulWidget {
  final DraftReport draft;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DraftCard({
    super.key,
    required this.draft,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<DraftCard> createState() => _DraftCardState();
}

class _DraftCardState extends State<DraftCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    setState(() => _pressed = true);
    _tapController.forward();
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
    _tapController.reverse();
  }

  void _handleTap() {
    setState(() => _pressed = false);
    _tapController.reverse();
    widget.onEdit();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapCancel: _handleTapCancel,
      onTapUp: (_) => _handleTap(),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title or placeholder
                    Text(
                      widget.draft.title?.isNotEmpty ?? false
                          ? widget.draft.title!
                          : localizations.untitledDraft,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Category if present
                    if (widget.draft.category != null &&
                        widget.draft.category!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CategoryChip(
                          category: widget.draft.category!,
                        ),
                      ),

                    // Description if available
                    if (widget.draft.description != null &&
                        widget.draft.description!.isNotEmpty) ...[
                      Text(
                        widget.draft.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Location if available
                    if (widget.draft.location != null &&
                        widget.draft.location!.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.draft.location!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Date footer with separator
                    Container(
                      height: 1,
                      color: theme.colorScheme.outline.withAlpha(50),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${localizations.lastModified} ${DateFormat('dd.MM.yyyy').format(widget.draft.lastModifiedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                // Delete button (matching ReportCard style)
                Positioned(
                  top: -8,
                  right: -8,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: theme.colorScheme.error,
                    ),
                    onPressed: widget.onDelete,
                    splashRadius: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
