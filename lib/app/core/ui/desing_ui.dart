
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* Nota 13 */
class DesingUi {

  DesingUi._();

  static ThemeData get theme => ThemeData(
    textTheme: GoogleFonts.kanitTextTheme(), // Definindo fonte padrão
    primaryColor: const Color(0xFF613E76),
    scaffoldBackgroundColor: const Color(0xFFF9FAFF),
    primaryColorLight: const Color(0xFFFFCCE2),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF7F82B9), // Definindo cor secundária, se necessário
      error: const Color(0xFFE63946), // Definindo cor de erro
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF613E76), // Cor para ElevatedButton
        foregroundColor: const Color(0xFFF9FAFF), // Cor do texto do botão
      ),
    )
  );  
  
}