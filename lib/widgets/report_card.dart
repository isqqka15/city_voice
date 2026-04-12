import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:city_voice_app/models/report.dart';
import 'package:city_voice_app/widgets/category_chip.dart';
import 'package:city_voice_app/utils/constants.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';

/// Enhanced report card with improved visual hierarchy and spacing.
/// Shows title, category, status, description, location, and date.
/// Includes tap feedback animation and delete option.
class ReportCard extends StatefulWidget {
  final Report report;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.onDelete,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails _) {
    setState(() => _pressed = true);
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
  }

  void _handleTap() {
    setState(() => _pressed = false);
    // Submitted reports cannot be edited - show message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.reportCannotBeEdited),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _canDelete() {
    // Can delete only if status is "not_reviewed"
    return widget.report.status == Statuses.notReviewed;
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete),
        content: Text(AppLocalizations.of(context)!.deleteReportConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete?.call();
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (widget.report.status) {
      case Statuses.notReviewed:
        return StatusColors.notReviewed(context);
      case Statuses.underReview:
        return StatusColors.underReview(context);
      case Statuses.approved:
        return StatusColors.approved(context);
      case Statuses.rejected:
        return StatusColors.rejected(context);
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  String _getLocalizedStatus() {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.report.status) {
      case Statuses.notReviewed:
        return l10n.statusNotReviewed;
      case Statuses.underReview:
        return l10n.statusUnderReview;
      case Statuses.approved:
        return l10n.statusApproved;
      case Statuses.rejected:
        return l10n.statusRejected;
      default:
        return widget.report.status.replaceAll('_', ' ').toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                    // Title with enhanced typography
                    Text(
                      widget.report.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    
                    // Category and Status chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(category: widget.report.category),
                          const SizedBox(width: 12),
                          // Status badge with enhanced styling
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor().withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getStatusColor().withAlpha(40),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _getLocalizedStatus(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _getStatusColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    
                    // Description with better typography
                    Text(
                      widget.report.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Location if available
                    if (widget.report.location != null) ...[
                      const SizedBox(height: 14),
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
                              widget.report.location!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Date footer with separator
                    const SizedBox(height: 14),
                    Container(
                      height: 1,
                      color: theme.colorScheme.outline.withAlpha(50),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      DateFormat('dd.MM.yyyy').format(widget.report.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                
                // Lock icon and delete button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      // Delete button - only for not_reviewed reports
                      if (_canDelete())
                        GestureDetector(
                          onTap: _showDeleteConfirmation,
                          child: Tooltip(
                            message: AppLocalizations.of(context)!.delete,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error.withAlpha(15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      // Lock icon - for under_review, approved, rejected (cannot delete)
                      if (!_canDelete())
                        Tooltip(
                          message: 'Cannot delete: Report is ${widget.report.status.replaceAll('_', ' ')}',
                          child: Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
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