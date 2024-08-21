import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/divider_with_text.dart';
import 'package:tymesavingfrontend/components/common/input/round_text_field.dart';
import 'package:tymesavingfrontend/form/signup_form.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_in_page.dart';
import 'package:tymesavingfrontend/screens/authentication/sign_up_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

void main() {
  group('SignUpView Tests', () {
    testWidgets('renders SignUpView widgets correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: SignUpView(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      // Assert
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Become a new user now!'), findsOneWidget);
      expect(find.byType(SignupForm), findsOneWidget);
      expect(find.byType(DividerWithText), findsOneWidget);

      // Verify Text.rich content
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText() ==
                  'Already have an account? Login here',
        ),
        findsOneWidget,
      );
    });

    testWidgets('navigates back to SignInView when "Login here" is tapped',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: SignUpView(),
        ),
      );

      // Act
      await tester.tap(find.text('Login here'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SignInView), findsOneWidget);
    });

    testWidgets('displays validation errors when fields are empty',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthService(),
          child: const MaterialApp(
            home: SignUpView(),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(Validator.validateUsername('')!), findsOneWidget);
      expect(find.text(Validator.validateEmail('')!), findsOneWidget);
      expect(find.text(Validator.validatePhone('')!), findsOneWidget);
      expect(find.text(Validator.validateFullName('')!), findsOneWidget);
      expect(find.text(Validator.validatePassword('')!), findsOneWidget);
      expect(find.text(Validator.validateConfirmPassword('', '')!),
          findsOneWidget);
    });

    testWidgets('calls sign-up service on form submission with valid data',
        (WidgetTester tester) async {
      // Arrange
      final mockAuthService = AuthService();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => mockAuthService,
          child: const MaterialApp(
            home: SignUpView(),
          ),
        ),
      );

      // Fill in the form with valid data
      await tester.enterText(
          find.widgetWithText(RoundTextField, 'Username'), 'testuser');
      await tester.enterText(
          find.widgetWithText(RoundTextField, 'Email'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(RoundTextField, 'Your phone number'),
          '+123456789');
      await tester.enterText(
          find.widgetWithText(RoundTextField, 'Your full name'), 'Test User');
      await tester.enterText(
          find.widgetWithText(RoundTextField, 'Password'), 'Password123!');
      await tester.enterText(
          find.widgetWithText(RoundTextField, 'Confirm Password'),
          'Password123!');

      // Act
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Assert
      // Assuming the AuthService is called and SignInView is pushed on success
      expect(find.byType(SignInView), findsOneWidget);
    });
  });
}
