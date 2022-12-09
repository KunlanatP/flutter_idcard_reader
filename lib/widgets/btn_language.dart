// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/constants/language.dart';
import 'package:flutter_idcard_reader/main.dart';
import 'package:flutter_idcard_reader/widgets/custom_button.dart';

class LanguageButtonWidget extends StatefulWidget {
  const LanguageButtonWidget({super.key});

  @override
  State<LanguageButtonWidget> createState() => _LanguageButtonWidgetState();
}

class _LanguageButtonWidgetState extends State<LanguageButtonWidget> {
  String _languageCode = 'en';

  @override
  void initState() {
    getLocale().then((value) {
      setState(() => _languageCode = value.languageCode);
    });
    super.initState();
  }

  void _changeLanguage(BuildContext context, String language) async {
    Locale locale = await setLocale(language);
    MyApp.setLocale(context, locale);
    setState(() => _languageCode = language);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    TextStyle? style = theme.button?.copyWith(
      color: Colors.grey,
    );
    TextStyle? styleFocus = theme.button?.copyWith(
      color: const Color(0xFF333335),
      fontWeight: FontWeight.bold,
    );
    return Row(
      children: [
        Center(
          child: CustomTextButtonWidget(
            text: translation(context).english_code,
            textStyle: _languageCode == 'en' ? styleFocus : style,
            onPressed: () => _changeLanguage(context, 'en'),
          ),
        ),
        const SizedBox(width: 10),
        Center(child: Text('|', style: theme.button)),
        const SizedBox(width: 10),
        Center(
          child: CustomTextButtonWidget(
            text: translation(context).thai_code,
            textStyle: _languageCode != 'en' ? styleFocus : style,
            onPressed: () => _changeLanguage(context, 'th'),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
