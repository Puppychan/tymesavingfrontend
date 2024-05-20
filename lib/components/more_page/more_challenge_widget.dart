import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/app_color.dart';
import 'package:tymesavingfrontend/common/app_text_style.dart';

class MoreMenuChallenge extends StatelessWidget {
  const MoreMenuChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cream,
      child: InkWell(
          splashColor: AppColors.tertiary,
          onTap: () {
            debugPrint('Challenge tapped.');
          },
          child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                children: [
                  Icon(Icons.emoji_events,
                      color: AppColors.primaryBlue, size: 30),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenge your saving skills now',
                        style: AppTextStyles.headingSmall,
                      ),
                      Text('Let\'s go!', style: AppTextStyles.boldHeadingBlue),
                    ],
                  )
                ],
              ))),
    );
  }
}
