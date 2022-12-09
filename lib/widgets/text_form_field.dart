// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_idcard_reader/widgets/custom_on_click.dart';

enum InputTypes { text, number }

class FormTextInput extends StatefulWidget {
  const FormTextInput({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.defaultValue = '',
    this.type = InputTypes.text,
    this.suffixLabel,
    this.hintText,
    this.helperText,
    this.autoFocus = false,
    this.errorText,
    this.autoChange = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.fillTextField,
    this.borderColor,
    this.hoverColor,
    this.suffixContent,
    this.clearTextIcon = false,
    this.width,
    this.height,
  }) : super(key: key);

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? defaultValue;
  final InputTypes type;
  final String? suffixLabel;
  final String? hintText;
  final String? helperText;
  final bool autoFocus;
  final String? errorText;
  final bool autoChange;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final Color? fillTextField;
  final Color? borderColor;
  final Color? hoverColor;
  final Widget? suffixContent;
  final bool obscureText;
  final bool clearTextIcon;
  final double? width;
  final double? height;

  @override
  State<FormTextInput> createState() => _FormTextInputState();
}

class _FormTextInputState extends State<FormTextInput> {
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
      hintText: widget.hintText,
      helperText: widget.helperText,
      hintStyle: theme.textTheme.bodyText2!
          .merge(const TextStyle(color: Color(0xFF7E7E7E))),
      errorText: widget.errorText,
      border: const OutlineInputBorder(),
      enabledBorder: widget.borderColor != null
          ? OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor!))
          : const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC8C8C8))),
      focusedBorder: widget.readOnly && widget.borderColor != null
          ? OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor!))
          : null,
      contentPadding: const EdgeInsets.all(10),
      fillColor: widget.fillTextField,
      hoverColor: widget.readOnly ? Colors.transparent : widget.hoverColor,
      suffixIconConstraints: const BoxConstraints(maxWidth: 68, minWidth: 32),
      suffixIcon: widget.suffixLabel != null
          ? Container(
              padding: const EdgeInsets.only(left: 4, right: 6),
              child: Text(
                widget.suffixLabel!,
                textAlign: TextAlign.right,
                style: theme.textTheme.button?.merge(
                  const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: -0.22,
                  ),
                ),
              ),
            )
          : widget.suffixContent ??
              (widget.clearTextIcon
                  ? (_textController.text == ''
                      ? null
                      : UICustomOnClick(
                          child: const Icon(
                            FluentIcons.dismiss_24_regular,
                            size: 16,
                          ),
                          onTap: () {
                            setState(() => _textController.clear());
                          },
                        ))
                  : null),
    );

    if (widget.autoChange) {
      _textController = TextEditingController(text: widget.defaultValue);
    }

    return SizedBox(
      height: widget.maxLines! > 1
          ? null
          : widget.helperText != null || widget.errorText != null
              ? 54
              : widget.height ?? 32,
      width: widget.width,
      child: TextField(
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        controller: _textController,
        style: theme.textTheme.bodyText2,
        keyboardType: widget.type == InputTypes.number
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
        inputFormatters: [
          if (widget.type == InputTypes.number)
            FilteringTextInputFormatter.digitsOnly
        ],
        obscureText: widget.obscureText,
        decoration: inputDecoration,
        onChanged: widget.onChanged,
        autofocus: widget.autoFocus,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
