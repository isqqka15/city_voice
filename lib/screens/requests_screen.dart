import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_voice_app/providers/report_provider.dart';
import 'package:city_voice_app/providers/draft_provider.dart';
import 'package:city_voice_app/screens/report_form_screen.dart';
import 'package:city_voice_app/screens/drafts_screen.dart';
import 'package:city_voice_app/screens/settings_screen.dart';
import 'package:city_voice_app/screens/support_faq_combined_screen.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/widgets/report_card.dart';
import 'package:city_voice_app/utils/animated_route.dart';
import 'package:city_voice_app/providers/auth_provider.dart';
import 'package:city_voice_app/providers/report_filter_provider.dart';

// Screen for displaying the list of reports.
// Loads reports on init, shows them in a modern Card-based ListView.
// Includes FAB to add new report, tap to edit, and delete option.
// Improved: Scrollable list with Cards displaying title, description, category, and date.
// Applied Material 3 theming with ColorScheme.fromSeed for consistent colors.
class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final Set<String> _visibleReportIds = {}; // Track by report ID, not index
  bool _hasAnimated = false;

  void _showFilterSheet(BuildContext ctx) {
    final filterProvider = ctx.read<ReportFilterProvider>();
    final l10n = AppLocalizations.of(ctx)!;
    // create temporary copies so changes only apply on 'Apply'
    final tempCategories = Set<Category>.from(filterProvider.categories);
    final tempStatuses = Set<FilterStatus>.from(filterProvider.statuses);
    var tempSort = filterProvider.sort;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (context, setState) {
            Widget buildSectionTitle(String t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(t, style: Theme.of(context).textTheme.titleMedium),
                );

            String getCategoryLabel(Category cat) {
              final l10n = AppLocalizations.of(context)!;
              switch (cat) {
                case Category.lighting:
                  return l10n.categoryLighting;
                case Category.garbage:
                  return l10n.categoryGarbage;
                case Category.roads:
                  return l10n.categoryRoads;
                case Category.waterSewage:
                  return l10n.categoryWaterSewage;
                case Category.publicSafety:
                  return l10n.categoryPublicSafety;
                case Category.other:
                  return l10n.categoryOther;
              }
            }

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle(l10n.categories),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      children: Category.values.map((cat) {
                        final selected = tempCategories.contains(cat);
                        final label = getCategoryLabel(cat);
                        return FilterChip(
                          label: Text(label),
                          selected: selected,
                          onSelected: (v) => setState(() => v ? tempCategories.add(cat) : tempCategories.remove(cat)),
                        );
                      }).toList(),
                    ),
                    buildSectionTitle(l10n.status),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      children: FilterStatus.values.map((st) {
                        final selected = tempStatuses.contains(st);
                        String label;
                        switch (st) {
                          case FilterStatus.notReviewed:
                            label = l10n.statusNotReviewed;
                            break;
                          case FilterStatus.underReview:
                            label = l10n.statusUnderReview;
                            break;
                          case FilterStatus.approved:
                            label = l10n.statusApproved;
                            break;
                          case FilterStatus.rejected:
                            label = l10n.statusRejected;
                            break;
                        }
                        return FilterChip(
                          label: Text(label),
                          selected: selected,
                          onSelected: (v) => setState(() => v ? tempStatuses.add(st) : tempStatuses.remove(st)),
                        );
                      }).toList(),
                    ),
                    buildSectionTitle(l10n.sortByDate),
                    Column(
                      children: DateSort.values.map((d) {
                        final label = d == DateSort.newestFirst ? l10n.newestFirst : l10n.oldestFirst;
                        return ListTile(
                          title: Text(label),
                          leading: Radio<DateSort>(
                            value: d,
                            groupValue: tempSort, // ignore: deprecated_member_use
                            onChanged: (v) => setState(() => tempSort = v!), // ignore: deprecated_member_use
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => setState(() {
                            tempCategories.clear();
                            tempStatuses.clear();
                            tempSort = DateSort.newestFirst;
                          }),
                          child: Text(l10n.clearFilters),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // apply to provider
                            filterProvider.setFilters(
                              categories: tempCategories,
                              statuses: tempStatuses,
                              sort: tempSort,
                            );
                            Navigator.of(context).pop();
                          },
                          child: Text(l10n.apply),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetAnimationState(); // Reset animation when screen initializes
      context.read<ReportProvider>().loadReports();
    });
  }

  void _resetAnimationState() {
    _visibleReportIds.clear();
    _hasAnimated = false;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          // Top bar with Drafts (left) and Filter, Settings (right)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              children: [
                // Left side: Drafts
                Consumer<DraftProvider>(
                  builder: (context, draftProvider, child) {
                    return Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.description,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            FadePageRoute(builder: (_) => const DraftsScreen()),
                          ),
                        ),
                        if (draftProvider.draftCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${draftProvider.draftCount}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                // Spacer to push right items to the right
                const Spacer(),
                // Right side: Filter and Settings
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () => _showFilterSheet(context),
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    FadePageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
              ],
            ),
          ),
          // Reports list
          Expanded(
            child: Consumer3<ReportProvider, AuthProvider, ReportFilterProvider>(
              builder: (context, provider, authProvider, filterProvider, child) {
                final reports = filterProvider.applyFilters(provider.reports.toList());
                
                // Reset animation state when reports list changes
                if (_hasAnimated && reports.length != _visibleReportIds.length) {
                  _resetAnimationState();
                }
                
                if (reports.isEmpty) {
                  return Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        localizations.noReports,
                        key: ValueKey(localizations.noReports),
                      ),
                    ),
                  );
                }

                // Trigger staggered appearance when reports first load
                if (!_hasAnimated && reports.isNotEmpty) {
                  _hasAnimated = true;
                  for (var i = 0; i < reports.length; i++) {
                    Future.delayed(Duration(milliseconds: 80 * i), () {
                      if (!mounted) return;
                      setState(() => _visibleReportIds.add(reports[i].id));
                    });
                  }
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  itemCount: reports.length,
                  // Use report ID as key to maintain animation state across list changes
                  key: ValueKey('reports_list_${reports.length}'),
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    final isVisible = _visibleReportIds.contains(report.id);
                    
                    return AnimatedOpacity(
                      key: ValueKey('report_${report.id}'),
                      duration: const Duration(milliseconds: 300),
                      opacity: isVisible ? 1 : 0,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        offset: isVisible ? Offset.zero : const Offset(0, 0.05),
                        child: ReportCard(
                          report: report,
                          onTap: () => Navigator.push(
                            context,
                            FadePageRoute(builder: (_) => ReportFormScreen(report: report)),
                          ),
                          onDelete: () async {
                            // Remove from visible set immediately for smooth deletion
                            setState(() => _visibleReportIds.remove(report.id));
                            // Then delete the report
                            await provider.deleteReport(report.id);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          // Support & FAQ button - bottom left
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              heroTag: 'support_faq_fab',
              mini: false,
              onPressed: () => Navigator.push(
                context,
                FadePageRoute(builder: (_) => const SupportAndFAQCombinedScreen()),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
          // Add Report button - bottom right
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              heroTag: 'add_report_fab',
              onPressed: () => Navigator.push(
                context,
                FadePageRoute(builder: (_) => const ReportFormScreen()),
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}