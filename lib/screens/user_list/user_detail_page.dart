import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/components/update_user_profile/build_info_template.dart';
import 'package:tymesavingfrontend/screens/user_profile/update_user_page.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserDetail extends StatefulWidget {
  final User user;
  const UserDetail({super.key, required this.user});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> with RouteAware {
  User? fetchedUser;
  void _fetchUserDetails() async {
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.getCurrentUserData(widget.user.username);
        // return result;
      }, () async {
        if (!mounted) return;
        setState(() {
          fetchedUser = userService.currentFetchUser;
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
    _fetchUserDetails();
    super.didPopNext();
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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const Heading(
        title: "User Detail",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppPaddingStyles.pagePadding,
        child: Column(
          children: [
            CustomAlignText(
                alignment: Alignment.bottomCenter,
                text:
                    "Joined ${timeago.format(DateTime.parse(fetchedUser?.creationDate ?? DateTime.now().toString()))}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontStyle: FontStyle.italic,
                    )),
            const Divider(),
            BuildInfo('Role', fetchedUser?.role.name ?? "Admin",
                const Icon(Icons.category_rounded)),
            BuildInfo('Full name', fetchedUser?.fullname ?? "Loading...",
                const Icon(Icons.badge_outlined)),
            BuildInfo('User name', fetchedUser?.username ?? "Loading...",
                const Icon(Icons.alternate_email_outlined)),
            BuildInfo('Phone', fetchedUser?.phone ?? "Loading...",
                const Icon(Icons.contact_phone_outlined)),
            BuildInfo('Email', fetchedUser?.email ?? "Loading...",
                const Icon(Icons.email_outlined)),
            // const Expanded( // cannot use along with SingleChildScrollView
            //   child: SizedBox(),
            // ),
            const SizedBox(
              height: 30,
            ),
            Card.filled(
              color: colorScheme.background,
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 50, vertical: 20),
              child: Column(
                children: [
                  PrimaryButton(
                      title: 'EDIT PROFILE', onPressed: openUpdateForm),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // SecondaryButton(
                  //     title: 'CHANGE PASSWORD', onPressed: openPasswordForm)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
