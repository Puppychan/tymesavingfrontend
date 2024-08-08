import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/group_saving/group_saving_card.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/group_saving_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/components/common/not_found_message.dart';

class GroupSavingListPage extends StatefulWidget {
  final User? user;
  const GroupSavingListPage({super.key, this.user});
  @override
  State<GroupSavingListPage> createState() => _GroupSavingListPageState();
}

class _GroupSavingListPageState extends State<GroupSavingListPage>
    with RouteAware {
  bool _isLoading = false;
  void _fetchGroupSavings() async {
    Future.microtask(() async {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      if (!mounted) return;
      final goalService =
          Provider.of<GroupSavingService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await goalService.fetchGroupSavingList(widget.user?.id);
      }, () async {});
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchGroupSavings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchGroupSavings();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchGroupSavings();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupSavingService>(builder: (context, goalService, child) {
      final groupSavings = goalService.groupSavings;

      return _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: AppPaddingStyles.pagePadding,
              child: groupSavings.isNotEmpty
                  ? ListView.separated(
                      itemCount: groupSavings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        return GroupSavingCard(
                            groupSaving: groupSavings[index]);
                      },
                    )
                  : const NotFoundMessage(message: "No group savings found"),
            );
    });
  }
}
