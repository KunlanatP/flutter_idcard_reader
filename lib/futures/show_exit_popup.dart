import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/constants/language.dart';

Future<bool> showExitPopup(context) async {
  final locale = await getLocale();

  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: locale.countryCode == 'th_TH' ? 90 : 91,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translation(context).exit_app_message),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => exit(0),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade800),
                        child: Text(translation(context).yes_message),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          translation(context).no_message,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}
