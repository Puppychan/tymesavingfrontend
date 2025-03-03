import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tymesavingfrontend/common/constant/temp_constant.dart';
import 'package:tymesavingfrontend/common/enum/rank_color_enum.dart';
import 'package:tymesavingfrontend/components/common/images/circle_network_image.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/base_user_model.dart';
import 'package:tymesavingfrontend/screens/user_profile/user_profile_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class UserBox extends StatefulWidget {
  const UserBox({super.key});

  @override
  State<UserBox> createState() => _UserBoxState();
}

class _UserBoxState extends State<UserBox> with RouteAware {
  UserBase? user;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
        setState(() {
          user = authService.user;
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
      if (mounted) {
        final authService = Provider.of<AuthService>(context, listen: false);
        await handleMainPageApi(context, () async {
          return await authService.getCurrentUserData();
          // return result;
        }, () async {
          setState(() {
            user = authService.user;
          });
        });
      }
    });
  }

  void goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        goToProfile();
      },
      child: Skeletonizer(
          enabled: user == null, // Show the skeleton if user is null
          child: Card(
            color: colorScheme.background, // Change color if skeleton
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading:
                        CustomCircleImage(imagePath: user?.avatar ?? TEMP_AVATAR_IMAGE),
                    title: Text(user?.fullname ?? 'Loading...',
                        style: Theme.of(context).textTheme.titleMedium!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.grade_outlined, size: 15, color: Theme.of(context).colorScheme.primary,),
                            Text(user?.rank ?? 'Loading rank...',
                            style: user == null ? 
                            Theme.of(context).textTheme.bodyMedium :
                            Theme.of(context).textTheme.bodyMedium!.copyWith(color: Rank.getRankColor(user!.rank))),
                          ],
                        ),
                        Text(user?.email ?? 'Loading mail...',
                        style: Theme.of(context).textTheme.bodyMedium!),
                      ],
                    )
                  )
                ],
              ),
            ),
          )),
    );
  }
}
