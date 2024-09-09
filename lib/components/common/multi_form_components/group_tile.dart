
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

  const GroupTile({
    super.key,
    required this.type,
    this.baseGroup,
    required this.onTap,
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
      }, () async {});
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
      return InkWell(
          splashColor: colorScheme.inversePrimary.withOpacity(0.5),
          onTap: () {
            Future.delayed(const Duration(milliseconds: 500), widget.onTap);
          },
          borderRadius: borderRadius,
          child: Stack(children: [
            Container(
              // background
              decoration: BoxDecoration(
                // color: Random().nextBool()
                //     ? colorScheme.tertiary
                //     : colorScheme.secondary,
                color: colorScheme.tertiary,
                // borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow,
                    spreadRadius: 0, // Spread radius
                    blurRadius: 1, // Blur radius
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            RoundedIcon(
                                size: 30,
                                backgroundColor: colorScheme.inversePrimary,
                                iconData:
                                    widget.type == TransactionGroupType.budget
                                        ? Icons.savings
                                        : Icons.assessment),
                            const SizedBox(width: 5),
                            Text(widget.type.toStringFormatted(),
                                style: textTheme.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 9),
                        Expanded(
                          child: Text(
                          widget.baseGroup?.name.toUpperCase() ?? "Loading...",
                          style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500,),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),),
                        const SizedBox(height: 5),
                        // Text(
                        //   widget.baseGroup?.description ?? "Loading...",
                        //   style: textTheme.titleSmall,
                        //   maxLines: 2,
                        // ),
                        // const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            widget.baseGroup?.description ?? "Loading...",
                            style: textTheme.bodyMedium,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          hostUser?.fullname.toUpperCase() ?? "Loading...",
                          style: textTheme.bodyMedium,
                          maxLines: 2,
                        )
                      ])),
            ),
          ]));
    });
  }
}
