import 'package:flutter/material.dart';

class RoundTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isPasswordField;
  final double componentHeight;
  final bool enabled;
  final String? Function(String?)? validator;

  const RoundTextField({
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
  });

  @override
  State<RoundTextField> createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  late bool _isObscure;
  String? _errorText;

  String? _validate(String? value) {
    String? errorMessage = widget.validator?.call(value);
    setState(() {
      _errorText = errorMessage;
    });
    return errorMessage;
  }

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
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.labelLarge!,
              ),
            )
          ],
        ),
        const SizedBox(height: 4),
        DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.18),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
              borderRadius: BorderRadius.circular(widget.componentHeight / 2),
            ),
            child: TextFormField(
              controller: widget.controller,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    colorScheme.tertiary.withOpacity(widget.enabled ? 1 : 0.7),
                hintText: widget.placeholder,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.componentHeight / 2),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.componentHeight / 2),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.componentHeight / 2),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.componentHeight / 2),
                  borderSide: BorderSide.none,
                ),
                errorStyle: const TextStyle(fontSize: 0, height: 0),
                suffixIcon: widget.isPasswordField
                    ? IconButton(
                        color: colorScheme.secondary,
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
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
              enabled: widget.enabled,
              validator: (value) {
                return _validate(value);
              },
            )),
        const SizedBox(height: 5),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              _errorText!,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
            ),
          ),
      ],
    );
  }
}
