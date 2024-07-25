import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/constant/temp_constant.dart';
import 'package:tymesavingfrontend/components/common/images/circle_network_image.dart';
import 'dart:math';

import 'package:tymesavingfrontend/models/base_user_model.dart';

class UserTile extends StatelessWidget {
  final UserBase user;
  final Function() onTap;

  const UserTile({super.key, required this.user, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
        splashColor: colorScheme.inversePrimary.withOpacity(0.5),
        onTap: () {
          Future.delayed(const Duration(milliseconds: 500), onTap);
        },
        borderRadius: borderRadius,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: _generateColors(),
              ),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  spreadRadius: 1, // Spread radius
                  blurRadius: 2, // Blur radius
                  offset: const Offset(2, 3), // changes position of shadow
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: colorScheme.surface.withOpacity(0.5),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCircleAvatar(
                          imagePath: user.avatar ?? TEMP_AVATAR_IMAGE,
                          radius: 35),
                      const SizedBox(height: 20),
                      Text(
                        user.fullname.toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.username.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                      )
                    ])),
          ),
        ]));
  }

  List<Color> _generateColors() {
    final random = Random();
    int firstIndex = random.nextInt(Colors.primaries.length);
    int secondIndex;

    do {
      secondIndex = random.nextInt(Colors.primaries.length);
    } while (secondIndex == firstIndex);

    // Use firstIndex and secondIndex to access distinct colors
    Color firstColor = Colors.primaries[firstIndex];
    Color secondColor = Colors.primaries[secondIndex];
    return [firstColor, secondColor];
  }
}
