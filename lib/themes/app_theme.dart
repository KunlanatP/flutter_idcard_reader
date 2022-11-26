import 'package:flutter/material.dart';
import 'package:flutter_idcard_reader/themes/text_theme.dart';

const transparentBorder =
    OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

class AppTheme {
  AppTheme._();
  static ThemeData get lightTheme {
    final ligth = ThemeData.light();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      primaryColorDark: Colors.grey.shade900,
      toggleableActiveColor: Colors.blueAccent,
      primarySwatch: Colors.blue,
      primaryColorLight: Colors.grey.shade100,
      backgroundColor: Colors.grey.shade200,
      scaffoldBackgroundColor: const Color(0xFFE4E4E4),
      indicatorColor: const Color(0xFFE4E4E4),
      textTheme: textTheme,
      iconTheme: ligth.iconTheme.merge(IconThemeData(
        size: 18,
        color: Colors.grey.shade700,
      )),
      primaryIconTheme: ligth.primaryIconTheme.merge(const IconThemeData(
        size: 18,
        color: Colors.blueAccent,
      )),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.red,
        hoverColor: Colors.grey.shade400.withAlpha(200),
        filled: true,
        border: transparentBorder,
        enabledBorder: transparentBorder,
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        focusedBorder: OutlineInputBorder(
          borderSide: border,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        buttonColor: Colors.lightBlue,
      ),
    );
  }

  static BorderSide get border =>
      BorderSide(color: Colors.blueAccent.shade200, width: 1);
  static ThemeData get darkTheme {
    final dark = ThemeData.dark();
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueAccent,
      toggleableActiveColor: Colors.blueAccent,
      primarySwatch: Colors.grey,
      primaryColorLight: Colors.grey.shade800,
      backgroundColor: Colors.grey.shade900,
      scaffoldBackgroundColor: Colors.black,
      textTheme: dark.textTheme.merge(textTheme),
      iconTheme: dark.iconTheme.merge(IconThemeData(
        size: 18,
        color: Colors.grey.shade400,
      )),
      primaryIconTheme: dark.primaryIconTheme.merge(
        const IconThemeData(size: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey.shade800.withAlpha(150),
        hoverColor: Colors.grey.shade800,
        filled: true,
        border: transparentBorder,
        enabledBorder: transparentBorder,
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        focusedBorder: OutlineInputBorder(
          borderSide: border,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        buttonColor: Colors.lightBlue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
