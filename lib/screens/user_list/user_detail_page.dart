import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/user/user_detail_widget.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_page.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class UserDetailPage extends StatefulWidget {
  final User user;
  final bool isViewByOther;
  final bool isViewYourself;
  const UserDetailPage(
      {super.key,
      required this.user,
      this.isViewByOther = false,
      this.isViewYourself = false});

  @override
  State<UserDetailPage> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetailPage> {
  void _fetchUserDetails() async {
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.getCurrentUserData(widget.user.username);
        // return result;
      }, () async {
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void openUpdateForm() {
    // final authService = Provider.of<AuthService>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateUserScreen(
                user: widget.user,
              )),
    );
  }

  // void openPasswordForm() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Heading(
        title: "User Detail",
        showBackButton: true,
        actions: [
          IconButton(
              onPressed: () => {openUpdateForm()},
              icon: const Icon(FontAwesomeIcons.userPen)),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppPaddingStyles.pagePaddingIncludeSubText,
        child: Consumer<UserService>(
          builder: (context, userService, child) {
            final user = userService.currentFetchUser;
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
