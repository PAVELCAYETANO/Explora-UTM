// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta institucional UTM
class AppColors {
  AppColors._();

  // Primarios
  static const Color azulPrimario = Color(0xFF003366); // Azul institucional UTM
  static const Color azulOscuro = Color(0xFF00214A);
  static const Color azulMedio = Color(0xFF004B8D);
  static const Color azulClaro = Color(0xFF1565C0);

  // Acentos
  static const Color dorado = Color(0xFFF5A623); // Naranja/Dorado institucional
  static const Color doradoClaro = Color(0xFFFFC947);
  static const Color doradoOscuro = Color(0xFFE8941F);

  // Neutros
  static const Color fondo = Color(0xFFF0F4F8);
  static const Color fondoTarjeta = Color(0xFFFFFFFF);
  static const Color textoOscuro = Color(0xFF0D1B35);
  static const Color textoMedio = Color(0xFF4A5568);
  static const Color textoClaro = Color(0xFF718096);
  static const Color borde = Color(0xFFE2E8F0);
  static const Color fondoChip = Color(0xFFEBF4FF);

  // Semánticos
  static const Color exito = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE53E3E);
  static const Color advertencia = Color(0xFFF6AD55);

  // Categorías (para marcadores y chips)
  static const Color academico = Color(0xFF3B82F6);
  static const Color servicios = Color(0xFF10B981);
  static const Color deportivo = Color(0xFFF59E0B);
  static const Color cultural = Color(0xFF8B5CF6);
  static const Color naturaleza = Color(0xFF22C55E);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.azulPrimario,
        primary: AppColors.azulPrimario,
        secondary: AppColors.dorado,
        surface: AppColors.fondoTarjeta,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.fondo,
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.manrope(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.textoOscuro,
        ),
        displayMedium: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textoOscuro,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textoOscuro,
        ),
        headlineSmall: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textoOscuro,
        ),
        titleLarge: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textoOscuro,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textoOscuro,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.textoMedio,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textoMedio,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textoClaro,
        ),
        labelLarge: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.azulPrimario,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.fondoTarjeta,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borde, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.azulPrimario,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.fondoChip,
        selectedColor: AppColors.azulPrimario,
        labelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.azulPrimario,
        unselectedItemColor: AppColors.textoClaro,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

/// Extensión de utilidad para obtener el color de cada categoría.
Color colorCategoria(categoria) {
  switch (categoria.toString()) {
    case 'CategoriaLugar.academico':
      return AppColors.academico;
    case 'CategoriaLugar.servicios':
      return AppColors.servicios;
    case 'CategoriaLugar.deportivo':
      return AppColors.deportivo;
    case 'CategoriaLugar.cultural':
      return AppColors.cultural;
    case 'CategoriaLugar.naturaleza':
      return AppColors.naturaleza;
    default:
      return AppColors.azulPrimario;
  }
}
