import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/user/member_card.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class MemberListPage extends StatefulWidget {
  final bool isBudgetGroup; // if true -> budget group, if false -> goal group
  final String groupId;
  const MemberListPage(
      {super.key, required this.isBudgetGroup, required this.groupId});
  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

Widget buildFood(String foodName) => ListTile(
      title: Text(foodName),
      onTap: () {},
    );

class _MemberListPageState extends State<MemberListPage> {
  // late List<Member> members = [];
  void _fetchMembers() async {
    Future.microtask(() async {
      if (!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.fetchGroupMemberList(
            widget.isBudgetGroup, widget.groupId);
      }, () async {
        // setState(() {
        //   members = memberService.members;
        // });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(builder: (context, memberService, child) {
      final members = memberService.members;
      final isCurrentUserHost = Provider.of<AuthService>(context).user?.id == members.firstWhere((element) => element.role == 'Host').user.id;
      return Scaffold(
          appBar: const Heading(
            title: "Members",
            showBackButton: true,
          ),
          body: Padding(
            padding: AppPaddingStyles.pagePadding,
            child: members.isNotEmpty
                ? ListView.separated(
                    itemCount: members.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      return MemberCard(
                        member: members[index],
                        isCurrentUserHost: isCurrentUserHost,
                        groupId: widget.groupId,
                        isBudgetGroup: widget.isBudgetGroup,
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ));
    });
  }
}
