import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/theme_mode_type_enum.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/filter_box.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/input/radio_field.dart';
import 'package:tymesavingfrontend/services/theme_service.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final themeList = ["Light", "Dark", "System Default", "Time-based"];

    // Determine the initial index based on the current theme
    int initialIndex = 0;
    switch (themeService.themeModeType) {
      case ThemeModeType.custom:
        if (themeService.themeMode == ThemeMode.light) {
          initialIndex = 0;
          break;
        }
        initialIndex = 1;
        break;
      case ThemeModeType.system:
        initialIndex = 2;
        break;
      default:
        // case ThemeModeType.time:
        initialIndex = 3;
    }

    return Scaffold(
        appBar: const Heading(title: "Setting page", showBackButton: true),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: AppPaddingStyles.pagePaddingIncludeSubText,
          child: Column(
            children: [
              Text("Choose your preferred theme",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              const Divider(),
              Text('Tips: Scroll to the right to see more option!', 
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic), 
              overflow: TextOverflow.visible,),
              RadioField(
              options: themeList,
                label: "Choose Theme",
                onSelected: (themeOption) {
                  switch (themeOption) {
                    case "Light":
                      themeService.setTheme(ThemeModeType.custom,
                          mode: ThemeMode.light);
                      break;
                    case "Dark":
                      themeService.setTheme(ThemeModeType.custom,
                          mode: ThemeMode.dark);
                      break;
                    case "System Default":
                      themeService.setTheme(ThemeModeType.system);
                      break;
                    case "Time-based":
                      themeService.setTheme(ThemeModeType.time);
                      break;
                    default:
                      break;
                  }
                },
                defaultOption: themeList[initialIndex],
              ),
            ],
          ),
        ));
  }
}
