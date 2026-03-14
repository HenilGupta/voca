import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An accessible card that merges semantics for screen readers
/// and provides haptic feedback on interaction.
class AccessibleCard extends StatelessWidget {
  const AccessibleCard({
    super.key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.semanticHint,
  });

  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;
  final String? semanticHint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: onTap != null,
      child: MergeSemantics(
        child: Card(
          child: InkWell(
            onTap: onTap != null
                ? () {
                    HapticFeedback.mediumImpact();
                    onTap!();
                  }
                : null,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
