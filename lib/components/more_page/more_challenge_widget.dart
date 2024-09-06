import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_text_style.dart';
import 'package:tymesavingfrontend/models/base_user_model.dart';
import 'package:tymesavingfrontend/screens/challenge/challenge_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class MoreMenuChallenge extends StatefulWidget {
  const MoreMenuChallenge({super.key});

  @override
  State<MoreMenuChallenge> createState() => _MoreMenuChallengeState();
}

class _MoreMenuChallengeState extends State<MoreMenuChallenge> {
  UserBase? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
        // return result;
      }, () async {
        setState(() {
          user = authService.user;
          isLoading = false;
        });
      });
    });
  }
  
  Future<void> challengePageRoute() async {
    //Debug here
    if (!mounted) return;
    debugPrint('Tracking page tapped!');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChallengePage(userId: user!.id,)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card.outlined(
      color: colorScheme.background,
      child: (isLoading) ?
      const CircularProgressIndicator() : 
      InkWell(
          splashColor: colorScheme.tertiary,
          onTap: () {
            debugPrint('Challenge tapped.');
            challengePageRoute();
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                children: [
                  Icon(Icons.emoji_events,
                      color: colorScheme.primary, size: 30),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenge your saving skills now',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 13),
                      ),
                      Text('Let\'s go!',
                          style: AppTextStyles.titleLargeBlue(context)),
                    ],
                  )
                ],
              ))),
    );
  }
}
