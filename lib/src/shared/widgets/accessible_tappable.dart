import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable widget that wraps its child in [Semantics],
/// ensures a minimum 48×48 tap target (WCAG), and triggers
/// haptic feedback on tap.
class AccessibleTappable extends StatelessWidget {
  const AccessibleTappable({
    super.key,
    required this.child,
    required this.onTap,
    required this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final String semanticLabel;
  final String? semanticHint;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      excludeSemantics: excludeSemantics,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          child: child,
        ),
      ),
    );
  }
}
