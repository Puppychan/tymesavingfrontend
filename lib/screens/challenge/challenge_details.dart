import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/challenge/challenge_details_member.dart';
import 'package:tymesavingfrontend/components/challenge/checkpoint_card.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ChallengeDetails extends StatefulWidget {
  const ChallengeDetails({super.key});

  @override
  State<ChallengeDetails> createState() => _ChallengeDetailsState();
}

class _ChallengeDetailsState extends State<ChallengeDetails> {
  ChallengeModel? _challengeModel;
  SummaryUser? _challengeOwner;
  List<ChallengeDetailMemberModel>? _challengeDetailMemberModelList;
  List<CheckPointModel>? _checkPointModelList;

  bool _isDisplayRestDescription = false;
  bool isLoading = true;

  String? createdDate;

  String formatDate(DateTime date){
    String formattedDate = DateFormat('MMMM d, y').format(date);
    return formattedDate;
  }
  
  Future<void> _loadChallenge(String? challengeId) async {
    Future.microtask(() async {
      if(!mounted) return;
      final challengeService = Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.fetchChallengeDetails(challengeId!);
      }, () async {
        if (!mounted) return;
          _challengeModel = challengeService.challengeModel;
          _challengeDetailMemberModelList = challengeService.challengeDetailMemberModelList;
          _checkPointModelList = challengeService.checkPointModelList;
          createdDate = formatDate(_challengeModel!.startDate);
      });
      await _loadChallengeUser(_challengeModel?.createdBy);
    });
  }

  Future<void> _loadChallengeUser(String? userId) async {
    Future.microtask(() async {
      if(!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await userService.getOtherUserInfo(userId);
      }, () async {
        if (!mounted) return;
        setState(() {
          _challengeOwner = userService.summaryUser;
         isLoading = false;
        });
      });
    });
  }

  Future<void> loadData() async {
    await _loadChallenge('69aa2c6b9b7fbb182d820d30');
    
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Scaffold(
    backgroundColor: colorScheme.tertiaryContainer,
    body: isLoading 
      ? const Center(child: CircularProgressIndicator())
      : CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: colorScheme.surface,
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Challenges detail",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                background: Container(
                  color: colorScheme.tertiary,
                  child: Center(
                    child: Text(
                      "Financial",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                              _challengeModel!.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                        Text(
                          _challengeModel!.category,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "By ${_challengeOwner!.fullname}",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                "$createdDate",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Text(
                        //   "${_challengeModel!.scope} ${_challengeModel!.budgetGroupId}",
                        //   style: Theme.of(context).textTheme.labelLarge,
                        // ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isDisplayRestDescription = !_isDisplayRestDescription;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _challengeModel!.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                  maxLines: _isDisplayRestDescription ? null : 2,
                                  overflow: _isDisplayRestDescription
                                      ? TextOverflow.visible
                                      : TextOverflow.fade,
                                ),
                                if (!_isDisplayRestDescription)
                                  Text(
                                    "Tap for more",
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                                "Challenge checkpoints",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                        const SizedBox(height: 10),
                        if (_checkPointModelList != null)
                          Column(
                            children: _checkPointModelList!.map((checkpoint) {
                              return CheckPointCard(checkpoint: checkpoint);
                            }).toList(),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                if (_challengeDetailMemberModelList != null && _challengeDetailMemberModelList!.isNotEmpty)
                Card.filled(
                  margin: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Text(
                          "Member participating",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 300, // Specify the height here
                              child: ListView.builder(
                                itemCount: _challengeDetailMemberModelList!.length,
                                itemBuilder: (context, index) {
                                  final member = _challengeDetailMemberModelList![index];
                                  return UserCard(
                                    username: member.username,
                                    fullname: member.fullname,
                                    avatar: member.avatar,
                                    rank: member.tymeReward,
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                )
              ]),
            ),
          ],
        ),
  );
}
}