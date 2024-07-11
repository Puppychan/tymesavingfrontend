import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/sheet/bottom_sheet.dart';
import 'package:tymesavingfrontend/components/common/sheet/icon_text_row.dart';
import 'package:tymesavingfrontend/components/user/user_detail_widget.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_page.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_password_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with RouteAware {
  User? user;

  void _fetchUserDetails() async {
    Future.microtask(() async {
      if (!mounted) return;
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
        // return result;
      }, () async {
        if (!mounted) return;
        setState(() {
          user = authService.user;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the current route shows up.
    _fetchUserDetails();
    super.didPopNext();
  }

  void openUpdateForm() {
    final authService = Provider.of<AuthService>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateUserScreen(
                user: authService.user,
              )),
    );
  }

  void openPasswordForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Heading(title: "My Profile", showBackButton: true, actions: [
        IconButton(
            onPressed: () {
              showStyledBottomSheet(
                  context: context,
                  title: 'Group Actions',
                  // initialChildSize: 0.3,
                  contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...actionRow(context, FontAwesomeIcons.userPen, "Edit User", () => openUpdateForm()),
                        ...actionRow(context, FontAwesomeIcons.lock, "Change Password", () => openPasswordForm()),
                        // TODO: add change pin
                        // ...actionRow(context, FontAwesomeIcons.userSecret, "Change PIN", () => null)
                      ]));
            },
            icon: const Icon(FontAwesomeIcons.cashRegister, size: 20))
      ]),
      body: SingleChildScrollView(
        padding: AppPaddingStyles.pagePadding,
        child: Consumer<AuthService>(
          builder: (context, userService, child) {
            final user = userService.user;
            return UserDetailWidget(
              fetchedUser: user,
              otherDetails: user?.getOtherFields(),
            );
          },
        ),
      ),
    );
  }
}
