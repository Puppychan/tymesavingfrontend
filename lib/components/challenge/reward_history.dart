import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/reward_history_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class RewardHistory extends StatefulWidget {
  const RewardHistory({
    super.key,
    required this.userId
    });

    final String userId;

  @override
  State<RewardHistory> createState() => _RewardHistoryState();
}

class _RewardHistoryState extends State<RewardHistory> with RouteAware {
  List<RewardHistoryModel>? _rewardHistoryModel;
  bool isLoading = true;
  String _selectedSortOptionDate = 'ascending';
  String _selectedSortOptionName = 'ascending';

  final Map<String, String> sortOptionsDate = {
    'ascending': 'Sort by Date (Ascending)',
    'descending': 'Sort by Date (Descending)',
  };

  final Map<String, String> sortOptionsName = {
    'ascending': 'Sort by Name (Ascending)',
    'descending': 'Sort by Name (Descending)',
  };

  Future<void> _loadRewardHistory() async {
    Future.microtask(() async {
      if (!mounted) return;
      final challengeService =
          Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.fetchRewardHistory(widget.userId, _selectedSortOptionDate, _selectedSortOptionName);
      }, () async {
        if (!mounted) return;
        setState(() {
          _rewardHistoryModel = challengeService.rewardHistoryList;
          isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _loadRewardHistory();
    super.initState();
  }

  Future<void> _pullRefresh() async {
    setState(() {
      isLoading = true;
      _loadRewardHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const Heading(
          title: 'Reward history', 
          showBackButton: true,
        ),
      body: isLoading ?
      const Center(child: CircularProgressIndicator()) : 
      Column(
        children: [
          Text('Sort by Date:', 
            style: textTheme.headlineMedium
          ),
          DropdownButton<String>(
            style: textTheme.bodyMedium!,
            value: _selectedSortOptionDate,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSortOptionDate = newValue!;
                _pullRefresh();
              });
            },
            items: sortOptionsDate.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Sort by Name:', 
            style: textTheme.headlineMedium
          ),
          DropdownButton<String>(
            style: textTheme.bodyMedium!,
            value: _selectedSortOptionName,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSortOptionName = newValue!;
                _pullRefresh();
              });
            },
            items: sortOptionsName.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
          ),
          const Divider(),
          Flexible(
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.builder(
                clipBehavior: Clip.hardEdge,
                    shrinkWrap: true,
                    itemCount: _rewardHistoryModel!.length,
                    itemBuilder: (context, index) {
                      final rewardTile = _rewardHistoryModel![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: colorScheme.surface,
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text.rich(
                                overflow: TextOverflow.visible,
                                TextSpan(
                                  text: 'Reward on ', // Default text style
                                  style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: DateFormat('MMM d, yyyy').format(DateTime.parse(rewardTile.checkpointPassedDate)),
                                      style: textTheme.bodyLarge!.copyWith(
                                          color: colorScheme.primary, 
                                          fontWeight: FontWeight.w500
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rewardTile.checkpointName, 
                                    style: textTheme.bodyMedium,
                                    overflow: TextOverflow.visible,),
                                  Text.rich(
                                    overflow: TextOverflow.visible,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${rewardTile.category} ', 
                                          style: textTheme.bodyMedium,
                                        ),
                                        TextSpan(
                                          text: 'received: ', 
                                          style: textTheme.bodyMedium!,
                                        ),
                                        TextSpan(
                                          text: '${rewardTile.value}', 
                                          style: textTheme.bodyMedium!.copyWith(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    overflow: TextOverflow.visible,
                                    TextSpan(
                                      text: 'From ', // Default text style
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: rewardTile.challengeName,
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              color: colorScheme.primary, 
                                              fontWeight: FontWeight.w500
                                            ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          )
        ],
      ),
    );
  }
}