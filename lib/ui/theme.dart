import 'package:flutter/material.dart';

ThemeData buildTheme() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontFamily: 'Pacifico',
        fontSize: 55.0,
        color: Colors.amber,
      ),
      button: base.button.copyWith(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
        color: Colors.white
      )
    );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();
  
  // And apply changes on it:
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    brightness: Brightness.light,
    accentColor: Colors.lightBlue
  );
}