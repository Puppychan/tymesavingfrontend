import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/theme_mode_type_enum.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/services/theme_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? _selectedThemeMode;
  final themeList = ["Light", "Dark", "System Default", "Time-based"];

  void _initSelectedThemeMode() {
    final themeService = Provider.of<ThemeService>(context, listen: false);
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
    setState(() {
      _selectedThemeMode = themeList[initialIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _initSelectedThemeMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const Heading(title: "Settings", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Select your preferred theme mode",
              style: textTheme.headlineMedium?.copyWith(
                color: isDark ? colorScheme.inversePrimary : colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildThemeOption(
                    title: 'Light Mode',
                    subtitle: 'A bright and vibrant look',
                    icon: Icons.wb_sunny_outlined,
                    themeModeString: themeList[0],
                  ),
                  const Divider(),
                  _buildThemeOption(
                    title: 'Dark Mode',
                    subtitle: 'A dark and elegant look',
                    icon: Icons.nights_stay_outlined,
                    themeModeString: themeList[1],
                  ),
                  const Divider(),
                  _buildThemeOption(
                    title: 'System Default',
                    subtitle: 'Follow device\'s system theme settings',
                    icon: Icons.settings_outlined,
                    themeModeString: themeList[2],
                  ),
                  const Divider(),
                  _buildThemeOption(
                    title: 'Time-based',
                    subtitle: 'Changes based on time of the day',
                    icon: Icons.timelapse,
                    themeModeString: themeList[3],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the action to save the selected theme mode
                // You can use any state management solution to persist this theme mode
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Theme mode set to ${_selectedThemeMode.toString().split('.').last}'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Theme',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each theme option
  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String themeModeString,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RadioListTile<String>(
      value: themeModeString,
      groupValue: _selectedThemeMode,
      activeColor: isDark ? colorScheme.inversePrimary : colorScheme.primary,
      onChanged: (String? newValue) {
        final themeService = Provider.of<ThemeService>(context, listen: false);
        if (newValue == null) {
          themeService.setTheme(ThemeModeType.system);
          return;
        }
        if (newValue == "Light") {
          themeService.setTheme(ThemeModeType.custom, mode: ThemeMode.light);
        } else if (newValue == "Dark") {
          themeService.setTheme(ThemeModeType.custom, mode: ThemeMode.dark);
        } else if (newValue == "System Default") {
          themeService.setTheme(ThemeModeType.system);
        } else {
          themeService.setTheme(ThemeModeType.time);
        }
        setState(() {
          _selectedThemeMode = newValue;
        });
      },
      title: Text(title),
      subtitle: Text(subtitle,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: colorScheme.secondary)),
      secondary: Icon(icon),
    );
  }
}
