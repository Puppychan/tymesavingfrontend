import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';

class RoundTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  // final TextAlign titleAlign;
  final bool obscureText;
  final bool isPasswordField;
  final double componentHeight = 58;
  final String? Function(String?)? validator; // Add a validator parameter

  const RoundTextField(
      {super.key,
      // this.titleAlign = TextAlign.left,
      required this.label,
      required this.placeholder,
      this.controller,
      this.isPasswordField = false,
      this.keyboardType,
      this.obscureText =
          false, // Whether the text should be obscured - hidden from view - for passwords
      this.validator});

  @override
  State<RoundTextField> createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  late bool _isObscure;
  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                textAlign: TextAlign.left,
                style: AppTextStyles.inputLabel,
              ),
            )
          ],
        ),
        // Space between label and input field
        const SizedBox(
          height: 4,
        ),
        // Input field
        Container(
          height: widget.componentHeight,
          width: double.maxFinite,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.tertiary,
            // border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(widget.componentHeight / 2),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.18),
                  offset: Offset(0, 2),
                  blurRadius: 4)
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            // autovalidateMode:AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              hintText: widget.placeholder,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              // icon
              suffixIcon: widget.isPasswordField
                  ? IconButton(
                      color: colorScheme.secondary,
                      icon: Icon(
                        _isObscure
                            ? Icons.visibility_off
                            : Icons.visibility, // Toggle the icon
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    )
                  : null,
            ),
            keyboardType: widget.keyboardType,
            obscureText: _isObscure,
            // validator: validator, // Use the validator
          ),
        )
      ],
    );
  }
}
