import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/transaction_group_type_enum.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';
import 'package:tymesavingfrontend/models/base_group_model.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GroupTile extends StatefulWidget {
  final TransactionGroupType type;
  final BaseGroup? baseGroup;
  final Function() onTap;

  const GroupTile(
      {super.key, required this.type, this.baseGroup, required this.onTap,
      });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {

  void renderUser() {
    Future.microtask(() async {
      await handleMainPageApi(context, () async {
        return await Provider.of<UserService>(context, listen: false)
            .getOtherUserInfo(widget.baseGroup?.hostedBy);
      }, () async {

      });
    });
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Consumer<UserService>(builder: (context, userService, child) {
      final hostUser = userService.summaryUser;
      return
    InkWell(
        splashColor: colorScheme.inversePrimary.withOpacity(0.5),
        onTap: () {
          Future.delayed(const Duration(milliseconds: 500), widget.onTap);
        },
        borderRadius: borderRadius,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.tertiary,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onBackground.withOpacity(0.3),
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
              color: colorScheme.background.withOpacity(0.5),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          RoundedIcon(
                              iconData: widget.type == TransactionGroupType.budget
                                  ? Icons.savings
                                  : Icons.assessment),
                          const SizedBox(width: 5),
                          Text(widget.type.toStringFormatted(),
                              style: textTheme.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.baseGroup?.name.toUpperCase() ?? "Loading...",
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.baseGroup?.name.toUpperCase() ?? "Loading...",
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.baseGroup?.description ?? "Loading...",
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      const SizedBox(height: 5),
                      Text(
                        hostUser?.fullname.toUpperCase() ?? "Loading...",
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                      )
                    ])),
          ),
        ]));
    });
  }

}