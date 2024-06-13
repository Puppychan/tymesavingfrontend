// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:tymesavingfrontend/components/round_text_field.dart';
// import 'package:tymesavingfrontend/components/primary_button.dart';
// import 'package:tymesavingfrontend/layouts/login_form.dart';
// import 'package:tymesavingfrontend/screens/HomePage.dart';
// import 'package:tymesavingfrontend/services/auth_service.dart';
// import 'package:tymesavingfrontend/utils/display_error.dart';
// import 'package:tymesavingfrontend/utils/validator.dart';

// import 'test_auth_service.mocks.dart';

// class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// void main() {
//   late MockAuthService mockAuthService;
//   late MockNavigatorObserver mockNavigatorObserver;

//   setUp(() {
//     mockAuthService = MockAuthService();
//     mockNavigatorObserver = MockNavigatorObserver();
//   });

//   Widget createWidgetUnderTest() {
//     return MaterialApp(
//       home: const Scaffold(
//         body: LoginForm(),
//       ),
//       navigatorObservers: [mockNavigatorObserver],
//     );
//   }

//   testWidgets('displays error message when username is empty',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     // Tap the sign in button
//     await tester.tap(find.text('Sign In'));
//     await tester.pump();

//     // Expect error message to be displayed
//     expect(find.text('Please enter a username'), findsOneWidget);
//   });

//   testWidgets('displays error message when password is empty',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(createWidgetUnderTest());

//     // Enter username
//     await tester.enterText(find.byType(RoundTextField).at(0), 'testuser');

//     // Tap the sign in button
//     await tester.tap(find.text('Sign In'));
//     await tester.pump();

//     // Expect error message to be displayed
//     expect(find.text('Please enter your password'), findsOneWidget);
//   });

//   testWidgets('calls signIn when username and password are provided',
//       (WidgetTester tester) async {
//     when(mockAuthService.signIn(any, any)).thenAnswer(
//         (_) async => {'token': 'fake_token'}); // Mock successful sign in

//     await tester.pumpWidget(
//       ChangeNotifierProvider<AuthService>(
//         create: (_) => mockAuthService,
//         child: createWidgetUnderTest(),
//       ),
//     );

//     // Enter username and password
//     await tester.enterText(find.byType(RoundTextField).at(0), 'testuser');
//     await tester.enterText(find.byType(RoundTextField).at(1), 'password');

//     // Tap the sign in button
//     await tester.tap(find.text('Sign In'));
//     await tester.pump();

//     // Verify signIn was called
//     verify(mockAuthService.signIn('testuser', 'password')).called(1);

//     // Verify navigation to HomePage
//     verify(mockNavigatorObserver.didPush(any, any));
//   });
// }
