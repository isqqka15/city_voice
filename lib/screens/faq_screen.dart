import 'package:flutter/material.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';

/// FAQ screen with searchable, collapsible FAQ items.
/// Features smooth animations for expanding/collapsing items.
class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _searchController = TextEditingController();
  final Set<int> _expandedItems = {};
  String _searchQuery = '';

  // FAQ items structure
  late List<FAQItem> _faqItems;
  late List<FAQItem> _filteredFaqItems;
  bool _faqItemsInitialized = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Moved context-dependent initialization from initState() to didChangeDependencies()
    // to safely use InheritedWidgets like Theme or Localizations
    if (!_faqItemsInitialized) {
      _initializeFAQItems();
      _faqItemsInitialized = true;
    }
  }

  void _initializeFAQItems() {
    final l10n = AppLocalizations.of(context)!;
    _faqItems = [
      FAQItem(
        question: l10n.faqItem1Q,
        answer: l10n.faqItem1A,
        icon: Icons.add_circle,
      ),
      FAQItem(
        question: l10n.faqItem2Q,
        answer: l10n.faqItem2A,
        icon: Icons.edit,
      ),
      FAQItem(
        question: l10n.faqItem3Q,
        answer: l10n.faqItem3A,
        icon: Icons.description,
      ),
      FAQItem(
        question: l10n.faqItem4Q,
        answer: l10n.faqItem4A,
        icon: Icons.save,
      ),
      FAQItem(
        question: l10n.faqItem5Q,
        answer: l10n.faqItem5A,
        icon: Icons.category,
      ),
      FAQItem(
        question: l10n.faqItem6Q,
        answer: l10n.faqItem6A,
        icon: Icons.image,
      ),
      FAQItem(
        question: l10n.faqItem7Q,
        answer: l10n.faqItem7A,
        icon: Icons.security,
      ),
      FAQItem(
        question: l10n.faqItem8Q,
        answer: l10n.faqItem8A,
        icon: Icons.wifi_off,
      ),
      FAQItem(
        question: l10n.faqItem9Q,
        answer: l10n.faqItem9A,
        icon: Icons.language,
      ),
      FAQItem(
        question: l10n.faqItem10Q,
        answer: l10n.faqItem10A,
        icon: Icons.help,
      ),
    ];
    _filteredFaqItems = List.from(_faqItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filterFAQ(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredFaqItems = List.from(_faqItems);
      } else {
        _filteredFaqItems = _faqItems
            .where((item) =>
                item.question.toLowerCase().contains(_searchQuery) ||
                item.answer.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  void _toggleExpanded(int index) {
    setState(() {
      if (_expandedItems.contains(index)) {
        _expandedItems.remove(index);
      } else {
        _expandedItems.add(index);
      }
    });
  }

  void _expandAll() {
    setState(() {
      for (int i = 0; i < _filteredFaqItems.length; i++) {
        _expandedItems.add(i);
      }
    });
  }

  void _collapseAll() {
    setState(() {
      _expandedItems.clear();
    });
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
          child: Column(
            children: [
              // Minimalist header with search
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: theme.colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.faq,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onChanged: _filterFAQ,
                      decoration: InputDecoration(
                        hintText: l10n.searchFAQ,
                        prefixIcon: Icon(Icons.search, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _filterFAQ('');
                              },
                            )
                            : null,
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
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant
                              .withAlpha(180),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expand/Collapse all buttons
              if (_filteredFaqItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _expandAll,
                        icon: Icon(Icons.unfold_more, size: 18),
                        label: Text(
                          l10n.expandAll,
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: _collapseAll,
                        icon: Icon(Icons.unfold_less, size: 18),
                        label: Text(
                          l10n.collapseAll,
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),

              // FAQ Items List
              Expanded(
                child: _filteredFaqItems.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 56,
                            color: theme.colorScheme.outlineVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noFAQFound,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: _filteredFaqItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredFaqItems[index];
                        final isExpanded = _expandedItems.contains(index);

                        return AnimatedFAQItem(
                          key: ValueKey('faq_$index'),
                          question: item.question,
                          answer: item.answer,
                          icon: item.icon,
                          isExpanded: isExpanded,
                          onTap: () => _toggleExpanded(index),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// FAQ Item model
class FAQItem {
  final String question;
  final String answer;
  final IconData icon;

  FAQItem({
    required this.question,
    required this.answer,
    required this.icon,
  });
}

/// Animated FAQ Item widget with smooth expand/collapse animation
class AnimatedFAQItem extends StatefulWidget {
  final String question;
  final String answer;
  final IconData icon;
  final bool isExpanded;
  final VoidCallback onTap;

  const AnimatedFAQItem({
    super.key,
    required this.question,
    required this.answer,
    required this.icon,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<AnimatedFAQItem> createState() => _AnimatedFAQItemState();
}

class _AnimatedFAQItemState extends State<AnimatedFAQItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedFAQItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded && !oldWidget.isExpanded) {
      _controller.forward();
    } else if (!widget.isExpanded && oldWidget.isExpanded) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withAlpha(128),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            children: [
              // Question header (always visible)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        // Icon with background
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            widget.icon,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Question text
                        Expanded(
                          child: Text(
                            widget.question,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Expand/Collapse indicator
                        RotationTransition(
                          turns: _rotateAnimation,
                          child: Icon(
                            Icons.expand_more,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Answer (collapsible with smooth animation)
              if (widget.isExpanded)
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(8),
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outlineVariant.withAlpha(100),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _heightAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          widget.answer,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
