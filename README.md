# TymeX Project Front-end

## Deploying - Hosting on Firebase
- Run `flutter build web` to build the web version of the app.
- Get android sha256 key
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```
- Create ./web/.well-known/assetlink.json:
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.tyme.tymesaving",
    "sha256_cert_fingerprints": ["<SHA256_KEY>"]
  }
}]
```

sudo gem install cocoapods

Momo sample response
https://webhook.site/04561cd2-489b-4982-9e68-5111a84a097a?partnerCode=MOMOBKUN20180529
orderId=OD1724389775564
requestId=RE1724389775564
amount=10000
orderInfo=Thanh+toan+hoa+don+OD1724389775564
orderType=momo_wallet
transId=1724389788015
resultCode=1006
message=Transaction+denied+by+user.
payType=
responseTime=1724389788018
extraData=
signature=2b419c014d9f8b7d80228c6ee4b26991d09e6538ca8a5077464d94dec723fc08

tymesaving://payment/momo?partnerCode=MOMO&orderId=66cadc7f5a82191b533164a1&requestId=MOMO1724570752146&amount=2000000&orderInfo=Pay+with+MoMo+66cadc7f5a82191b533164a1+Topup+Wallet&orderType=momo_wallet&transId=4106436272&resultCode=0&message=Successful.&payType=napas&responseTime=1724570893342&extraData=&signature=60259330d208594a1e848332d664584a55fdf943f59c966587640489c8223f58

## Install For Deep Link
flutter clean
flutter build apk
flutter install

## Test Deep Link:

Android: adb shell am start -W -a android.intent.action.VIEW -d "tyme_saving://payment/momo"
IOS: xcrun simctl openurl booted tyme_saving://payment/momo

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

## Adding App Icon
- Use link to generate app icon: [https://easyappicon.com/](https://easyappicon.com/)
- After generating the app icon, download the zip file and extract it.
  - Copy the content of `ios` folder to `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  - Copy the content of `android` folder to `android/app/src/main/res/`
  - Add files inside `values` folder to `android/app/src/main/res/values/`
- Run command to update the app icon
```bash
  flutter pub cache clean
  flutter pub clean
  flutter pub get
```
- Run the app on the emulator or real device to see the updated app icon.

## Testing on Android and iOS Simulators

### Android Simulator:

- Ensure you have an Android Virtual Device (AVD) set up in Android Studio.
- Start the AVD from Android Studio or via the command line:

```bash
emulator -avd <your_avd_name>
```

- Run the application on the simulator:

```bash
flutter run
```

### iOS Simulator:

- Ensure you have Xcode installed and configured on your machine.
- Open the iOS simulator from Xcode or via the command line:

```bash
open -a Simulator
```

- Run the application on the simulator:

```bash
flutter run
```

## Testing on Real Devices

### Android Device:

- Enable Developer Options and USB Debugging on your Android device.
- Connect your Android device to your machine via USB.
- Verify the device is recognized:

```bash
flutter devices
```

-Run the application on the device:

```bash
flutter run
```

### iOS Device:

- Connect your iOS device to your machine via USB.
- Open the project - folder ios in Xcode.
- Ensure your device is selected as the target.
- Run the application on the device via Xcode or the command line:

```bash
flutter run
```
- If you encounter issues:
  - Messsage of the issues to be "... is not available because it is unpaired." -> Unplug the device and plug it back in until there is modal pop up on the device asking for trust the computer. Trust the computer and run the command again.
  - Message is about "...is not available. Please unlock..." -> Unlock the device and rerun the command again.
  - Message is about "Could not build ... because the following modules are missing:..." -> Run the command:
    - flutter pub upgrade
    - flutter clean
    - flutter pub get
    - ```
      cd ios
      rm -rf Pods
      rm -rf Podfile.lock
      pod install
    ```
  - Rerun the command again.
  - Message is about "...enable Developer Mode in Settings → Privacy & Security.":
    - In the device: Go to Settings -> General -> Device Management -> Developer App -> Trust the app.
    - The app is restarted -> Confirm "On" for developer mode -> rerun the command again.
  
