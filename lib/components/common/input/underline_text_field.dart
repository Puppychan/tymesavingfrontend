import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';

class UnderlineTextField extends StatefulWidget {
  final String label;
  final dynamic placeholder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isPasswordField;
  final double componentHeight;
  final bool enabled;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final IconData? icon;
  final String? defaultValue;
  final Function()? onTap;
  final bool? readOnly;
  final void Function(String)? onChange;

  const UnderlineTextField({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.isPasswordField = false,
    this.keyboardType,
    this.enabled = true,
    this.obscureText = false,
    this.validator,
    this.componentHeight = 58,
    this.suffixIcon,
    this.icon,
    this.onTap,
    this.readOnly,
    this.onChange, this.defaultValue,
  });

  @override
  State<UnderlineTextField> createState() => _UnderlineTextFieldState();
}

class _UnderlineTextFieldState extends State<UnderlineTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      widget.controller!.text = widget.defaultValue!;
    }
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label, style: textTheme.titleSmall),
      const SizedBox(height: 10),
      TextFormField(
        controller: widget.controller,
        onChanged: widget.onChange,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly ?? false,
        style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.divider, width: 1.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.divider, width: 1.5),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onError),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onBackground),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          // labelStyle: textTheme.bodyLarge,
          // labelText: title,
          hintText: widget.placeholder,
          prefixIcon: Icon(widget.icon),
          enabled: widget.enabled,
          errorStyle: textTheme.bodySmall!.copyWith(color: colorScheme.onError),
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(widget.suffixIcon),
                  onPressed: widget.onTap,
                )
              : null,
        ),
      ),
      const SizedBox(height: 30),
    ]);
  }
}
