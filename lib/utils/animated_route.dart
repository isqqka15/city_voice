import 'package:flutter/material.dart';

/// Simple fade and slide page route helpers with short durations.
class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required WidgetBuilder builder, super.settings, Duration? duration})
      : super(
          pageBuilder: (context, animation, secondary) => builder(context),
          transitionDuration: duration ?? const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondary, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            return FadeTransition(opacity: curved, child: child);
          },
        );
}

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  SlidePageRoute({required WidgetBuilder builder, super.settings, Duration? duration, Offset begin = const Offset(0.0, 0.25)})
      : super(
          pageBuilder: (context, animation, secondary) => builder(context),
          transitionDuration: duration ?? const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondary, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            final offset = Tween<Offset>(begin: begin, end: Offset.zero).animate(curved);
            return SlideTransition(position: offset, child: child);
          },
        );
}
