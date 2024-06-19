class Validator {
  // Validate email addresses
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    String pattern = r'^\w+@\w+\.\w+$'; // Improved pattern for simplicity
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // null means no error
  }

  // Validate passwords
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8 || value.length > 20) {
      return "Password must be at least 8 characters and at most 20 characters";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least 1 uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least 1 lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least 1 digit";
    }
    if (!RegExp(r'[!@#\$%^&*]').hasMatch(value)) {
      return "Password must contain at least 1 of the following characters !@#\$%^&*";
    }
    if (!RegExp(r'^[A-Za-z0-9!@#\$%^&*]*$').hasMatch(value)) {
      return "Password can only be A-Z a-z 0-9 !@#\$%^&*";
    }
    return null;
  }

  // Validate confirmation password
  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please enter your confirmation password';
    }
    if (password != confirmPassword) {
      return 'Confirmation password does not match';
    }
    return null; // null means no error
  }

// Validate full name
  static String? validateFullName(String? fullName) {
    if (fullName == null || fullName.isEmpty) {
      return 'Please enter your full name';
    }
    if (!fullName.contains(' ')) {
      return 'Please enter both first and last name';
    }
    return null; // null means no error
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

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length >= 8 &&
        value.length <= 15 &&
        RegExp(r'^[A-Za-z0-9]*$').hasMatch(value)) {
      return null;
    } else {
      return "Username must be 8-15 characters long and can only contain alphanumeric characters";
    }
  }

  // Validate phone numbers
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    String pattern =
        r'^\+?([0-9]{1,3})?[-. ]?([0-9]{9,10})$'; // Simple pattern for international and local phone numbers
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    if (value.length < 4) {
      return 'Title must be at least 4 characters long';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    print("Validate amount: $value");
    const minAmount = 100;
    if (value == null || value.isEmpty) {
      return 'Amount cannot be empty';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < minAmount) {
      return 'Amount must be greater than $minAmount dong';
    }
    return null; // null means the input is valid
  }
}
