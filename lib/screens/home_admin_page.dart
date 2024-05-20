import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';
import 'package:tymesavingfrontend/components/text_align.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/user.model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

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

  @override
  Widget build(BuildContext context) {
    return const Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      // Image.asset("assets/img/app_logo_light.svg",
      //     width: media.width * 0.5, fit: BoxFit.contain),
      CustomAlignText(
          text: 'View our user list here!', style: AppTextStyles.subHeading),
      SizedBox(
        height: 24,
      ),
    ]);
  }
}
