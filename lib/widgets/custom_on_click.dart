import 'package:flutter/material.dart';

class UICustomOnClick extends StatelessWidget {
  const UICustomOnClick({
    Key? key,
    required this.child,
    this.onTap,
    this.onShowFocusHighlight,
    this.onShowHoverHighlight,
    this.onFocusChange,
    this.tooltip,
  }) : super(key: key);

  final Widget child;
  final GestureTapCallback? onTap;
  final ValueChanged<bool>? onShowFocusHighlight;
  final ValueChanged<bool>? onShowHoverHighlight;
  final ValueChanged<bool>? onFocusChange;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    var content = child;

    if (tooltip != null) {
      content = Tooltip(
        message: tooltip,
        child: content,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: FocusableActionDetector(
          onShowFocusHighlight: onShowFocusHighlight,
          onShowHoverHighlight: onShowHoverHighlight,
          onFocusChange: onFocusChange,
          child: content,
        ),
      ),
    );
  }
}
