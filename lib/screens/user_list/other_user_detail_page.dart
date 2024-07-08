import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/components/user/user_detail_widget.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class OtherUserDetailPage extends StatefulWidget {
  final SummaryUser otherUser;
  final bool isViewByOther;
  final bool isViewYourself;
  const OtherUserDetailPage(
      {super.key,
      required this.otherUser,
      this.isViewByOther = false,
      this.isViewYourself = false});

  @override
  State<OtherUserDetailPage> createState() => _OtherUserDetailState();
}

class _OtherUserDetailState extends State<OtherUserDetailPage> {
  void _fetchOtherUserDetails() async {
    Future.microtask(() async {
      if (!mounted) return;
      final otherUserService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await otherUserService.getOtherUserInfo(widget.otherUser.id);
        // return result;
      }, () async {});
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOtherUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(
        title: "OtherUser Detail",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: AppPaddingStyles.pagePaddingIncludeSubText,
        child: Consumer<UserService>(
          builder: (context, otherUserService, child) {
            final otherUser = otherUserService.summaryUser;
            return UserDetailWidget(
              fetchedUser: otherUser,
              otherDetails: otherUser?.getOtherFields(),
            );
          },
        ),
      ),
    );
  }
}
