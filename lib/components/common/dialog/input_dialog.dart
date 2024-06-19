import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/input/round_text_field.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';

void showInputDialog(
    {required BuildContext context,
    required String label,
    required String placeholder,
    Function? successCall,
    String? Function(String?)? validator,
    TextInputType? type}) {

  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> trySubmit() async {
    // Validate the form
    final isValid = formKey.currentState?.validate();
    final inputValue = controller.text;
    if (isValid == null || !isValid) {
      // final String? validateMessage = validator?.call(controller.text);
      final String? validateMessage = validator!(inputValue);
      if (validateMessage != null) {
        ErrorDisplay.showErrorToast(validateMessage, context);
        return;
      }
      return;
    }
    // if success
    successCall!(inputValue);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(placeholder),
        content: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundTextField(
                    label: label,
                    keyboardType: type,
                    placeholder: placeholder,
                    controller: controller,
                    isPasswordField: false,
                    validator: validator,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: trySubmit,
            child: const Text('Confirm'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
