import 'package:flutter/material.dart';
import 'package:city_voice_app/models/report_feed_model.dart';

/// Social feed for user reports with expandable content, animations, pull-to-refresh and infinite scroll
class ReportsFeedScreen extends StatefulWidget {
  const ReportsFeedScreen({super.key});

  @override
  State<ReportsFeedScreen> createState() => _ReportsFeedScreenState();
}

class _ReportsFeedScreenState extends State<ReportsFeedScreen>
    with TickerProviderStateMixin {
  late List<Report> _reports;
  late ScrollController _scrollController;
  late RefreshController _refreshController;
  bool _isLoading = false;

  late AnimationController _pageLoadAnimationController;
  late Animation<double> _pageLoadFadeAnimation;

  @override
  void initState() {
    super.initState();
    _reports = ReportFeedSampleData.getSampleReports();
    _scrollController = ScrollController();
    _refreshController = RefreshController(initialRefresh: false);

    // Page load animation
    _pageLoadAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pageLoadFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pageLoadAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _pageLoadAnimationController.forward();

    // Infinite scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _refreshController.dispose();
    _pageLoadAnimationController.dispose();
    super.dispose();
  }

  /// Handle infinite scroll - load more reports when near bottom
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      if (!_isLoading) {
        _loadMoreReports();
      }
    }
  }

  /// Load more reports for infinite scroll
  Future<void> _loadMoreReports() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      // Add new reports to the feed
      _reports.addAll(ReportFeedSampleData.getSampleReports());
    });
  }

  /// Handle pull-to-refresh
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _reports = ReportFeedSampleData.getSampleReports();
    });
    _refreshController.refreshCompleted();
  }

  /// Handle like button tap
  void _toggleLike(int index) {
    setState(() {
      final report = _reports[index];
      _reports[index] = report.copyWith(
        isLiked: !report.isLiked,
        likes: report.isLiked ? report.likes - 1 : report.likes + 1,
      );
    });
  }

  /// Handle comment button tap
  void _openComments(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening comments for report: ${_reports[index].id}'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  /// Handle share button tap
  void _shareReport(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing report: ${_reports[index].id}'),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports Feed'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: FadeTransition(
        opacity: _pageLoadFadeAnimation,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: _reports.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              // Loading indicator at bottom
              if (index == _reports.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              }

              final report = _reports[index];

              return ReportCard(
                report: report,
                index: index,
                onLikeTap: () => _toggleLike(index),
                onCommentTap: () => _openComments(index),
                onShareTap: () => _shareReport(index),
                tickerProvider: this,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Individual report card widget with animations
class ReportCard extends StatefulWidget {
  final Report report;
  final int index;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final TickerProvider tickerProvider;

  const ReportCard({
    super.key,
    required this.report,
    required this.index,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.tickerProvider,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _cardAnimationController;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Card entrance animation
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _cardSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _cardAnimationController,
            curve: Curves.easeOut,
          ),
        );

    // Stagger animations based on index
    Future.delayed(Duration(milliseconds: 50 * (widget.index + 1)), () {
      if (mounted) {
        _cardAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNewReport = widget.report.isNew;
    final maxLines = _isExpanded ? null : 3;

    return SlideTransition(
      position: _cardSlideAnimation,
      child: FadeTransition(
        opacity: _cardFadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isNewReport
                  ? theme.colorScheme.primary.withAlpha(180)
                  : theme.colorScheme.outlineVariant.withAlpha(100),
              width: isNewReport ? 2 : 1,
            ),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info and new badge
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User avatar
                    UserAvatar(
                      name: widget.report.userName,
                      avatarUrl: widget.report.userAvatar,
                    ),
                    const SizedBox(width: 12),
                    // User info and timestamp
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.report.userName,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isNewReport)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'New',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimestamp(widget.report.createdAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Report content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text content with expandable option
                    GestureDetector(
                      onTap: () {
                        setState(() => _isExpanded = !_isExpanded);
                      },
                      child: Text(
                        widget.report.content,
                        maxLines: maxLines,
                        overflow: TextOverflow.fade,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    // Show "Read more" button if content is long
                    if (widget.report.content.length > 100 && !_isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Read more',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    // Image if available
                    if (widget.report.imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: Icon(Icons.image),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Report actions (like, comment, share)
              ReportActions(
                report: widget.report,
                onLikeTap: widget.onLikeTap,
                onCommentTap: widget.onCommentTap,
                onShareTap: widget.onShareTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Format timestamp to readable format
  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

/// User avatar widget
class UserAvatar extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const UserAvatar({
    super.key,
    required this.name,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _getInitials(name);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary.withAlpha(80),
      ),
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Get initials from name
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

/// Report actions bar (like, comment, share)
class ReportActions extends StatefulWidget {
  final Report report;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;

  const ReportActions({
    super.key,
    required this.report,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
  });

  @override
  State<ReportActions> createState() => _ReportActionsState();
}

class _ReportActionsState extends State<ReportActions>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;

  @override
  void initState() {
    super.initState();

    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _likeScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _likeAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleLike() {
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });
    widget.onLikeTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Like button with animation
          Expanded(
            child: _ActionButton(
              icon: widget.report.isLiked ? Icons.favorite : Icons.favorite_border,
              label: '${widget.report.likes}',
              color: widget.report.isLiked
                  ? Colors.red
                  : theme.colorScheme.onSurfaceVariant,
              onTap: _handleLike,
              animation: _likeScaleAnimation,
            ),
          ),
          // Comment button
          Expanded(
            child: _ActionButton(
              icon: Icons.comment_outlined,
              label: '${widget.report.comments}',
              color: theme.colorScheme.onSurfaceVariant,
              onTap: widget.onCommentTap,
            ),
          ),
          // Share button
          Expanded(
            child: _ActionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              color: theme.colorScheme.onSurfaceVariant,
              onTap: widget.onShareTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual action button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Animation<double>? animation;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Apply animation if provided (for like button)
    if (animation != null) {
      return ScaleTransition(scale: animation!, child: button);
    }

    return button;
  }
}

/// Refresh controller for pull-to-refresh functionality
class RefreshController {
  final bool initialRefresh;

  RefreshController({this.initialRefresh = false});

  void refreshCompleted() {
    // Called when refresh is complete
  }

  /// Clean up any resources held by the controller.
  void dispose() {
    // No-op for now; provided to match expected API.
  }
}
