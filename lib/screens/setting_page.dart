import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/filter_box.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/services/theme_service.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final themeList = ["Light", "Dark", "System Default", "Time-based"];

    // Determine the initial index based on the current theme
    int initialIndex = 0;
    if (themeService.useSystemThemeBasedOnTime) {
      initialIndex = 3;
    } else {
      switch (themeService.themeMode) {
        case ThemeMode.light:
          initialIndex = 0;
          break;
        case ThemeMode.dark:
          initialIndex = 1;
          break;
        case ThemeMode.system:
          initialIndex = 2;
          break;
        default:
          initialIndex = 2; // Fallback to System Default
      }
    }

    return Scaffold(
        appBar: const Heading(title: "Setting page", showBackButton: true),
        body: SingleChildScrollView(
          padding: AppPaddingStyles.pagePaddingIncludeSubText,
          child: Column(
            children: [
              Text("Choose your preferred theme",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              const Divider(),
              FilterBox(
                filterData: themeList,
                label: "Choose Theme",
                onToggle: (index) {
                  switch (index) {
                    case 0:
                      themeService.setTheme(ThemeMode.light);
                      break;
                    case 1:
                      themeService.setTheme(ThemeMode.dark);
                      break;
                    case 2:
                      themeService.setTheme(ThemeMode.system);
                      break;
                    case 3:
                      themeService.toggleSystemThemeBasedOnTime();
                      break;
                    default:
                      break;
                  }
                },
                defaultConditionInit: (currentIndex) =>
                    currentIndex == initialIndex,
              ),
            ],
          ),
        ));
  }
}
