import 'package:flutter/material.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:janus/core/constants/appcolor.dart';
import 'package:janus/core/constants/fontsize.dart';
import 'package:janus/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final InputBorder? border;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showPrefixIcon;
  final bool showSuffixIcon;
  final String? Function(String?)? validator;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLines;
  final Color? fillColor;
  final bool enabled;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode? autovalidateMode;

  /// Custom text field with consistent styling
  ///
  /// bg color change: set [fillColor], defaults to theme-based background
  /// Validation errors automatically clear when user corrects the input
  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.border,
    this.prefixIcon,
    this.suffixIcon,
    this.showPrefixIcon = true,
    this.showSuffixIcon = true,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.fillColor,
    this.enabled = true,
    this.focusNode,
    this.contentPadding,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final InputBorder effectiveBorder =
        border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CustomAppColor.grey, width: 1.5),
        );

    // Inactive/Enabled border - shows gray light
    final InputBorder effectiveEnabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: CustomAppColor.grey, width: 1.5),
    );

    // Active/Focused border - shows primary color
    final InputBorder effectiveFocusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: CustomAppColor.primary, width: 1.5),
    );

    final InputBorder effectiveErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(11.5),
      borderSide: BorderSide(color: CustomAppColor.primary, width: 1.5),
    );

    final Color effectiveFillColor =
        fillColor ?? (isDark ? AppColors.darkCard : AppColors.lightCard);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      initialValue: controller == null ? initialValue : null,
      validator: validator,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enabled,
      focusNode: focusNode,
      decoration: InputDecoration(
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        hintText: hintText,
        labelText: labelText,
        hintStyle: AppTextStyle.custom(
          fontWeight: FontWeight.normal,
          fontSize: CustomFontSize.bodyMedium,
          color: CustomAppColor.grey,
        ),
        labelStyle: AppTextStyle.custom(
          fontSize: CustomFontSize.bodyMedium,
          color: CustomAppColor.subtext,
        ),
        border: effectiveBorder,
        enabledBorder: effectiveEnabledBorder,
        focusedBorder: effectiveFocusedBorder,
        errorBorder: effectiveErrorBorder,
        focusedErrorBorder: effectiveErrorBorder,
        prefixIcon: showPrefixIcon ? prefixIcon : null,
        suffixIcon: showSuffixIcon ? suffixIcon : null,
        counterText: maxLength == null ? null : '',
        filled: true,
        fillColor: effectiveFillColor,
        errorStyle: AppTextStyle.error,
      ),
      style: AppTextStyle.custom(fontSize: CustomFontSize.bodyMedium),
    );
  }
}
