import 'package:flutter/material.dart';

class AppColors {
  // --- Branding Colors ---

  // --- Modern Tech Palette (Commented out for future use) ---
  // static const Color primary = Color(0xFF316EF3); // Vibrant Blue
  // static const Color secondary = Color(0xFF7609E8); // Vibrant Purple

  // Primary: Primary Buttons Active Inputs etc.
  static const Color primary = Color(0xFF00E5FF); // Neon Cyan

  // Secondary
  static const Color secondary = Color(0xFF2979FF); // Neon Blue

  // Background: Deep elegant dark
  static const Color background = Color(0xFF0B0F19);

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

  static const Color success = Color(0xFF10B981); // Emerald

  static const Color warning = Color(0xFFF59E0B);

  static const Color error = Color(0xFFEF4444);

  // --- Gradients ---
  // Modern Tech Gradient (Blue to Purple)
  // static const LinearGradient primaryGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [Color(0xFF316EF3), Color(0xFF7609E8)],
  // );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00E5FF), Color(0xFF2979FF)], // Neon Cyan to Blue
  );
}
