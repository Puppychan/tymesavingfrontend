import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/goal/goal_card.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/goal_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class GoalListPage extends StatefulWidget {
  final User? user;
  const GoalListPage({super.key, this.user});
  @override
  State<GoalListPage> createState() => _GoalListPageState();
}

class _GoalListPageState extends State<GoalListPage> {
  void _fetchGoals() async {
    Future.microtask(() async {
      if (!mounted) return;
      final goalService = Provider.of<GoalService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await goalService.fetchGoalList(widget.user?.id);
      }, () async {
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalService>(builder: (context, goalService, child) {
      final goals = goalService.goals;
      return Padding(
          padding: AppPaddingStyles.pagePadding,
          child: goals.isNotEmpty
              ? ListView.separated(
                  itemCount: goals.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    return GoalCard(goal: goals[index]);
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ));
    });
  }
}
