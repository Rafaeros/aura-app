import 'package:aura/core/utils/app_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aura/core/presentation/theme/app_colors.dart';

enum AuraFieldBehavior { text, password, clipboard }

class AuraTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final AuraFieldBehavior behavior;
  final Widget? prefixIcon;
  final Widget? customSuffixIcon;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final bool hasBorder;

  const AuraTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.behavior = AuraFieldBehavior.text,
    this.prefixIcon,
    this.customSuffixIcon,
    this.onChanged,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.textInputAction,
    this.fillColor,
    this.hasBorder = false,
  });

  @override
  State<AuraTextField> createState() => _AuraTextFieldState();
}

class _AuraTextFieldState extends State<AuraTextField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() => _isObscured = !_isObscured);
  }

  Future<void> _copyToClipboard() async {
    final text = widget.controller?.text ?? '';
    if (text.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: text));

    if (mounted) {
      AppNotifications.showSuccess(
        context: context,
        message: "Copiado para a área de transferência!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordBehavior = widget.behavior == AuraFieldBehavior.password;
    final shouldObscure = isPasswordBehavior && _isObscured;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType:
              isPasswordBehavior
                  ? TextInputType.visiblePassword
                  : widget.keyboardType,
          obscureText: shouldObscure,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),

          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
            ),
            filled: true,
            fillColor: widget.fillColor ?? AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  widget.hasBorder
                      ? BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      )
                      : BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.redAccent.withValues(alpha: 0.8),
                width: 1,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    switch (widget.behavior) {
      case AuraFieldBehavior.password:
        return IconButton(
          icon: Icon(
            _isObscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: _toggleVisibility,
        );

      case AuraFieldBehavior.clipboard:
        return IconButton(
          icon: const Icon(
            Icons.copy_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          onPressed: _copyToClipboard,
        );

      case AuraFieldBehavior.text:
    }

    return widget.customSuffixIcon;
  }
}
