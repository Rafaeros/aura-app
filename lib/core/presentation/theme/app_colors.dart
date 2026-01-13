import 'package:flutter/material.dart';

class AppColors {
  // --- Branding Colors ---

  // Primary: Primary BUttons Active Inputs etc.
  static const Color primary = Color(0xFF00E5FF);

  // Secondary
  static const Color secondary = Color(0xFF2979FF);

  // Background: "Void Blue"  background
  static const Color background = Color(0xFF0F172A);

  // Surface: Card and Inputs
  static const Color surface = Color(0xFF1E293B);

  // --- Tipography (Dark Mode) ---

  // Text Primary: Principal
  static const Color textPrimary = Color(0xFFF8FAFC);

  // Text Secondary: Subtitles
  static const Color textSecondary = Color(0xFF94A3B8);

  // --- Inputs  ---
  static const Color accent = Color(0xFF334155);

  static const Color utils = Color(0xFF475569);

  // -- Alerts --
  static const Color info = Color(0xFF3B82F6);

  static const Color success = Color(0xFF22C55E);

  static const Color warning = Color(0xFFF59E0B);

  static const Color error = Color(0xFFEF4444);

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
  );
}
