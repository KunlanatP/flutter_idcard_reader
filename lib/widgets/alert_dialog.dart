import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../themes/text_theme.dart';

Future<void> showDialogConfirm(
  String label,
  BuildContext context,
  VoidCallback? onPressed,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialogWidget(
        label: label,
        onPressed: onPressed,
      );
    },
  );
}

class AlertDialogWidget extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const AlertDialogWidget({
    Key? key,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  State<AlertDialogWidget> createState() => _AlertDeleteWidgetState();
}

class _AlertDeleteWidgetState extends State<AlertDialogWidget> {
  bool isHoverCancle = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.label,
        style: textTheme.titleMedium,
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.cancle_message,
            style: textTheme.titleSmall!.merge(
              TextStyle(
                color: isHoverCancle
                    ? Colors.blueAccent.shade400
                    : Colors.grey.shade500,
              ),
            ),
          ),
          onHover: (value) => setState(() => isHoverCancle = value),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text(
            AppLocalizations.of(context)!.txt_save,
            style: textTheme.titleSmall!.merge(
              const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
