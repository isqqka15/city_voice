import 'package:flutter/material.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/utils/constants.dart';

/// Enhanced category chip with improved styling and visual hierarchy.
/// Uses predefined colors for each category with better contrast and spacing.
class CategoryChip extends StatelessWidget {
  final String category;
  final bool dense;

  const CategoryChip({
    super.key,
    required this.category,
    this.dense = false,
  });

  String _getLocalizedCategory(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case Categories.lighting:
        return l10n.categoryLighting;
      case Categories.garbage:
        return l10n.categoryGarbage;
      case Categories.roads:
        return l10n.categoryRoads;
      case Categories.waterSewage:
        return l10n.categoryWaterSewage;
      case Categories.publicSafety:
        return l10n.categoryPublicSafety;
      case Categories.other:
        return l10n.categoryOther;
      default:
        return category;
    }
  }

  Color _getCategoryColor() {
    switch (category) {
      case Categories.lighting:
        return CategoryColors.lighting;
      case Categories.garbage:
        return CategoryColors.garbage;
      case Categories.roads:
        return CategoryColors.roads;
      case Categories.waterSewage:
        return CategoryColors.waterSewage;
      case Categories.publicSafety:
        return CategoryColors.publicSafety;
      case Categories.other:
        return CategoryColors.other;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();
    final text = _getLocalizedCategory(context);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 10 : 12,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(60),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}