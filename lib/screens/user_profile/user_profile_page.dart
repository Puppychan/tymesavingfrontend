import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_padding.dart';
import 'package:tymesavingfrontend/components/app_bar_return.dart';
import 'package:tymesavingfrontend/components/heading.dart';
import 'package:tymesavingfrontend/components/primary_button.dart';
import 'package:tymesavingfrontend/components/secondary_button.dart';
import 'package:tymesavingfrontend/layouts/update_user_form.dart';
import 'package:tymesavingfrontend/models/user.model.dart';
import 'package:tymesavingfrontend/screens/more_menu/more_page.dart';
import 'package:tymesavingfrontend/components/update_user_profile/build_info_template.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_page.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_password_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User? user;
  final String fullName = 'Zang Zuong';
  final String userName = 'zinggiang';
  final String phone = '0123456789';
  final String email = 'c.test123@gmail.com';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageError(context, () async {
        return await authService.getCurrentUserData();
        // return result;
      }, () async {
        setState(() {
          user = authService.user;
        });
      });
    });
  }

  void openUpdateForm() {
    final authService = Provider.of<AuthService>(context, listen: false);
    List<String> valueList = [];
    valueList.add(fullName);
    valueList.add(userName);
    valueList.add(phone);
    valueList.add(email);
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
      backgroundColor: AppColors.cream,
      appBar: const Heading(
        title: "My Profile",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppPaddingStyles.pagePadding,
        child: Column(
          children: [
            BuildInfo('Full name', user?.fullname ?? "Loading...",
                const Icon(Icons.badge_outlined)),
            BuildInfo('User name', user?.username ?? "Loading...",
                const Icon(Icons.alternate_email_outlined)),
            BuildInfo('Phone', user?.phone ?? "Loading...",
                const Icon(Icons.contact_phone_outlined)),
            BuildInfo('Email', user?.email ?? "Loading...",
                const Icon(Icons.email_outlined)),
            // const Expanded( // cannot use along with SingleChildScrollView
            //   child: SizedBox(),
            // ),
            const SizedBox(
              height: 30,
            ),
            Card.filled(
              color: AppColors.white,
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 50, vertical: 20),
              child: Column(
                children: [
                  PrimaryButton(
                      title: 'EDIT PROFILE', onPressed: openUpdateForm),
                  const SizedBox(
                    height: 5,
                  ),
                  SecondaryButton(
                      title: 'CHANGE PASSWORD', onPressed: openPasswordForm)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
