import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextButtonWidget extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final Color? textColor;

  const CustomTextButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.textStyle,
    this.textColor,
  });

  @override
  State<CustomTextButtonWidget> createState() => _CustomTextButtonWidgetState();
}

class _CustomTextButtonWidgetState extends State<CustomTextButtonWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomOnClick(
      onTap: widget.onPressed,
      onShowHoverHighlight: (value) => setState(() => isHovered = value),
      child: Text(
        widget.text,
        style: (widget.textStyle ?? theme.textTheme.subtitle1)!.copyWith(
          color: isHovered ? Colors.blue : widget.textColor,
        ),
      ),
    );
  }
}

class CustomOnClick extends StatelessWidget {
  const CustomOnClick({
    super.key,
    required this.child,
    this.onTap,
    this.onShowHoverHighlight,
  });

  final Widget child;
  final GestureTapCallback? onTap;
  final ValueChanged<bool>? onShowHoverHighlight;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: FocusableActionDetector(
          onShowHoverHighlight: onShowHoverHighlight,
          child: child,
        ),
      ),
    );
  }
}

const _fillColor = Color(0xFFF8FAFC);
const _strokeColor = Color(0xFFE2E8F0);
const _textColor = Color(0xFF333335);

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    this.icon,
    required this.label,
    this.onPressed,
    this.color,
    this.labelStyle,
  });

  final FaIcon? icon;
  final String label;
  final void Function()? onPressed;
  final Color? color;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 42),
          maximumSize: const Size(double.infinity, 42),
          backgroundColor: color ?? _fillColor,
          side: BorderSide(color: color ?? _strokeColor),
        ),
        icon: icon!,
        label: Text(
          label,
          style: labelStyle ??
              theme.textTheme.subtitle1!.copyWith(color: _textColor),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 42),
        maximumSize: const Size(double.infinity, 42),
        backgroundColor: color ?? _fillColor,
        side: BorderSide(color: color ?? _strokeColor),
      ),
      child: Text(
        label,
        style: labelStyle ??
            theme.textTheme.subtitle1!.copyWith(color: _textColor),
      ),
    );
  }
}
