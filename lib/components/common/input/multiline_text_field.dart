import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultilineTextField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isPasswordField;
  final bool enabled;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final String? defaultValue;
  final Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final bool expands;
  final bool alignLabelWithHint;

  const MultilineTextField({
    Key? key,
    required this.label,
    this.placeholder,
    this.controller,
    this.isPasswordField = false,
    this.keyboardType,
    this.enabled = true,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
    this.onChange,
    this.defaultValue,
    this.inputFormatters,
    this.minLines = 5,
    this.maxLines,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.expands = false,
    this.alignLabelWithHint = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (label.isNotEmpty)
        //   Text(
        //     label,
        //     style: labelStyle ?? theme.textTheme.bodyMedium,
        //   ),
        // const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChange,
          validator: validator,
          keyboardType: keyboardType ?? TextInputType.multiline,
          readOnly: readOnly,
          inputFormatters: [...inputFormatters ?? []],
          enabled: enabled,
          minLines: minLines,
          maxLines: maxLines,
          expands: expands,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: label,
            hintText: placeholder,
            hintStyle: hintStyle ?? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
            labelStyle: labelStyle ?? theme.textTheme.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onTap,
                  )
                : null,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            alignLabelWithHint: alignLabelWithHint,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
