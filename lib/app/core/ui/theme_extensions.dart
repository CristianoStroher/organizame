import 'package:flutter/material.dart';



/* Nota 14 */
extension ThemeExtensions on BuildContext {

  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get buttonColor => Theme.of(this).colorScheme.primary;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get errorColor => Theme.of(this).colorScheme.error;
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle get titleBig => TextStyle(
    fontSize: 30,
    fontFamily: 'Kanit',
    fontWeight: FontWeight.bold,
    color: primaryColor,
    );

    TextStyle get titleMedium => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  TextStyle get titleDefaut => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: secondaryColor,
  );



  

}