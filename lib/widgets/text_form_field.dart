// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/themes/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? defaultValue;
  final double? width;
  final String? labelText;
  final String? hintText;
  // final String? helperText;
  // final String? counterText;
  final Widget? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final bool filled;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    Key? key,
    this.defaultValue = '',
    this.width,
    this.labelText,
    this.hintText,
    // this.helperText,
    // this.counterText,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.filled = true,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _textController;
  @override
  void initState() {
    _textController = TextEditingController(text: widget.defaultValue);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inputDecoration = InputDecoration(
      filled: widget.filled,
      fillColor: widget.fillColor ?? Colors.transparent,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: theme.primaryColor,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: textFieldBorder, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      labelText: widget.labelText,
      labelStyle: theme.textTheme.bodyText2,
      hintText: widget.hintText,
      hintStyle: theme.textTheme.bodyText2?.merge(
        const TextStyle(color: textFieldBorder),
      ),
      // helperText: widget.helperText,
      // counterText: widget.counterText,
      icon: widget.icon,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
    );

    Widget child = TextFormField(
      controller: _textController,
      decoration: inputDecoration,
      style: theme.textTheme.bodyText2?.merge(
        const TextStyle(color: textColor),
      ),
      onChanged: widget.onChanged,
    );

    if (widget.width != null) {
      child = SizedBox(
        width: widget.width,
        height: 32,
        child: child,
      );
    }

    return child;
  }
}
