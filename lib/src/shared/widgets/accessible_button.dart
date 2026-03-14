import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An accessible button with minimum 48×48 tap target,
/// semantic labeling, and haptic feedback.
class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticHint,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? semanticHint;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final button =
        outlined
            ? OutlinedButton.icon(
              onPressed: onPressed == null ? null : _handlePress,
              icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
              label: Text(label),
            )
            : ElevatedButton.icon(
              onPressed: onPressed == null ? null : _handlePress,
              icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
              label: Text(label),
            );

    return Semantics(
      label: label,
      hint: semanticHint,
      button: true,
      child: button,
    );
  }

  void _handlePress() {
    if (onPressed == null) {
      return;
    }
    HapticFeedback.mediumImpact();
    onPressed!();
  }
}
