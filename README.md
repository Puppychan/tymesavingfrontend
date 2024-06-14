
# TymeX Project Front-end

## Introduction
Welcome to the TymeX Front-End repository! This repository contains the source code for the mobile finance application "TymeX," developed as part of a capstone project. TymeX aims to provide users with a seamless and intuitive financial management experience on their mobile devices.
## Overview
TymeX is built using Flutter and Dart, allowing for a cross-platform application that runs smoothly on both iOS and Android devices. This repository includes all the necessary files to build, run, and maintain the front-end of the application.
## Team members/contributors
- Tran Mai Nhung - Lead Front-end Developer
- Vo Thanh Thong - Front-end Developer
- Giang Trong Duong - Front-end Developer

## Installation
### Prerequisites
- Ensure to setup .env based on .example.env
- Ensure to have Flutter installed on your machine
- Ensure to have an emulator or a physical device connected to your machine
### Steps
1. Clone the repository to your local machine
   ```bash
   git clone https://bitbucket.org/tyme-ni-rmit/tymesavingfrontend/src/main/
   ```
2. Navigate to the project directory
   ```bash
    cd tymesavingfrontend
    ```
3. Install the required dependencies
    ```bash
    flutter pub get
    ```
**Option Steps**
- If you want to run the backend server locally, please follow the instruction in the backend repository and running backend server locally. Then paste the local server URL to the .env file.

4. Run the application
   ```bash
   flutter run
   ```

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
