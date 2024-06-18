import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/user_list/user_list_page.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> with RouteAware {
  late User? user; // Assuming User is a defined model

  @override
  void initState() {
    super.initState();
    // Future.microtask(() async {
    //   if (!mounted) return;
    //   final authService = Provider.of<AuthService>(context, listen: false);
    //   await handleMainPageApi(context, () async {
    //     return await authService.getCurrentUserData();
    //     // return result;
    //   }, () async {
    //     setState(() {
    //       user = authService.user;
    //     });
    //   });
    // });
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
  Widget build(BuildContext context) {
    return Padding(
        padding: AppPaddingStyles.pagePaddingIncludeSubText,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Image.asset("assets/img/app_logo_light.svg",
          //     width: media.width * 0.5, fit: BoxFit.contain),
          CustomAlignText(
              text: 'View our user list here!',
              style: Theme.of(context).textTheme.headlineMedium!),
          const SizedBox(
            height: 24,
          ),
          const UserListPage(),
        ]));
  }
}
