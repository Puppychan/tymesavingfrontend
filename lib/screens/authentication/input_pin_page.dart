import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/screens/main_page_layout.dart';

class InputPinPage extends StatefulWidget {
  const InputPinPage({super.key});

  @override
  State<InputPinPage> createState() => _InputPinPageState();
}

class _InputPinPageState extends State<InputPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  void _validatePin() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate an API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      if (_pinController.text == "1234") { // Replace this with your actual PIN validation logic
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainPageLayout()), // Navigate to your desired page
        );
      } else {
        _errorMessage = "Invalid PIN. Please try again.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter PIN'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please enter your PIN',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    decoration: InputDecoration(
                      labelText: 'PIN',
                      border: const OutlineInputBorder(),
                      errorText: _errorMessage,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your PIN';
                      }
                      if (value.length != 4) {
                        return 'PIN must be 4 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _validatePin,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
