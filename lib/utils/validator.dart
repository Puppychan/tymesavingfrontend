class Validator {
  // Validate email addresses
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    String pattern = r'^\w+@\w+\.\w+$';  // Improved pattern for simplicity
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;  // null means no error
  }

  // Validate passwords
  static String? validatePassword(String? value) {
    print("Password here: $value after");
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      print("Password must be at least 8 characters long");
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  // Validate usernames
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length < 4) {
      return 'Username must be at least 4 characters long';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  // Validate phone numbers
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    String pattern = r'^\+?([0-9]{1,3})?[-. ]?([0-9]{9,10})$';  // Simple pattern for international and local phone numbers
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
