import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/constant/temp_constant.dart';
import 'package:tymesavingfrontend/components/common/custom_shape_painter.dart';
import 'package:tymesavingfrontend/components/common/images/rounded_network_image.dart';
import 'package:tymesavingfrontend/components/common/text_align.dart';
import 'package:tymesavingfrontend/components/update_user_profile/build_info_template.dart';
import 'package:tymesavingfrontend/models/base_user_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserDetailWidget extends StatelessWidget {
  final UserBase? fetchedUser;
  final Map<String, dynamic>? otherDetails;

  const UserDetailWidget({
    super.key,
    this.fetchedUser,
    this.otherDetails,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(children: [
      CustomPaint(
        size: const Size(double.infinity, 220), // Specify your custom size
        painter: CustomShapePainter(
          color: colorScheme.brightness == Brightness.dark
              ? colorScheme.primary.withOpacity(0.3)
              : colorScheme.inversePrimary.withOpacity(0.3),
        ),
      ),
      Column(
        children: [
          if (otherDetails?['role'] != null &&
              otherDetails?['creationDate'] != null)
            CustomAlignText(
                alignment: Alignment.bottomCenter,
                maxLines: 2,
                text:
                    "${otherDetails?['role'].toString() ?? "Role..."} - Joined ${timeago.format(DateTime.parse(otherDetails?['creationDate'] ?? DateTime.now().toString()))}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.secondary,
                    )),
          const SizedBox(height: 10),
          CustomRoundedImage(
            imagePath: fetchedUser?.avatar ?? TEMP_AVATAR_IMAGE,
            size: 100.0,
          ),
          const SizedBox(height: 10),
          CustomAlignText(
              alignment: Alignment.bottomCenter,
              maxLines: 2,
              text: fetchedUser?.fullname ?? "Loading...",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 5),
          CustomAlignText(
              alignment: Alignment.bottomCenter,
              maxLines: 2,
              text: "@${fetchedUser?.username ?? "Loading..."}",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: colorScheme.secondary,
                  )),
          const SizedBox(height: 10),
          const Divider(),
          BuildInfo('Rank', fetchedUser?.rank ?? "Loading...",
              const Icon(Icons.star_border_outlined)),
          BuildInfo('Total point', fetchedUser?.userPoint.toString() ?? "Loading...",
              const Icon(Icons.account_balance_wallet_outlined)),
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
        ],
      )
    ]);
  }
}
