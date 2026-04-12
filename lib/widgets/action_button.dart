import 'package:flutter/material.dart';

/// Action button widget for interactive form elements like Select Location, Select Date, Attach Evidence.
/// Features:
/// - Subtle border with color accent
/// - Hover/press feedback with smooth animations
/// - Clear icons with proper spacing
/// - Minimalistic design that maintains app consistency
/// - Accessible on all device sizes
class ActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final double? width;
  final bool isLoading;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.width,
    this.isLoading = false,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    Color p(double o) => primaryColor.withAlpha((o * 255).round());

    return SizedBox(
      width: widget.width ?? double.infinity,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.isLoading ? null : widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // Animated border - thicker and darker on hover
                border: Border.all(
                  color: _isHovered ? p(0.6) : p(0.3),
                  width: _isHovered ? 2 : 1.5,
                ),
                // Subtle background color change on hover
                color: _isHovered ? p(0.08) : p(0.04),
                // Shadow elevation on hover
                boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: p(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).round()),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else ...[
                    // Icon with color accent
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: _isHovered ? primaryColor : p(0.7),
                      ),
                      child: Icon(
                        widget.icon,
                        color: _isHovered ? primaryColor : p(0.7),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  // Text with weight emphasis on hover
                  if (!widget.isLoading)
                    Expanded(
                      child: Text(
                        widget.text,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _isHovered ? primaryColor : p(0.8),
                          fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  // Subtle chevron icon on the right to indicate interactivity
                  if (!widget.isLoading) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: _isHovered ? primaryColor : p(0.5),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
