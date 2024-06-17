import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/user/user_sort_filter.dart';
import 'package:tymesavingfrontend/services/theme_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class Heading extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const Heading({super.key, required this.title, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeService>(context);

    void _fetchUsers() async {
      Future.microtask(() async {
        // if (!mounted) return;
        final userService = Provider.of<UserService>(context, listen: false);
        await handleMainPageApi(context, () async {
          return await userService.fetchUserList();
        }, () async {
          // setState(() {
          //   users = userService.users;
          // });
        });
      });
    }

    return AppBar(
      title: CustomAlignText(text: title),
      leading: showBackButton
          ? IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24.0,
                semanticLabel: 'Back to previous page',
              ),
            )
          : null,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
        IconButton(
            onPressed: () => showStyledBottomSheet(
                context: context,
                title: "Filter",
                contentWidget: UserSortFilter(updateUserList: _fetchUsers)),
            icon: Icon(Icons.filter_outlined))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
