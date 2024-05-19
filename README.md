# tymesavingfrontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# For Dev
## Add Native Splash Screen
- Ensure to have flutter_native_splash in your pubspec.yaml
- Run `flutter pub get` to install the package
- Customize your desired splash screen in the pubspec.yaml:
    ```yaml
        flutter_native_splash:
            android: true
            ios: true
            web: false
            image: assets/splash.png
            color: "#FFFFFF"
            android_12:
                image: assets/splash.png
                color: "#FFFFFF"
    ```
- Run `flutter pub run flutter_native_splash:create` to generate the splash screen
- dart run flutter_native_splash:create
