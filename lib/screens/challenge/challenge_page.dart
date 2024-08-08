import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/challenge/challenge_card.dart';

import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ChallengePage extends StatefulWidget {
  final String? userId;
  final String? budgetGroupId;
  final String? savingGroupId;
  const ChallengePage(
      {super.key, this.userId, this.budgetGroupId, this.savingGroupId});
  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  List<ChallengeModel>? _challengeModelList;
  bool isLoading = true;

  Future<void> _loadChallengeList(String? userId) async {
    Future.microtask(() async {
      if (!mounted) return;
      final challengeService =
          Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        // TODO: remove later
        final tempUserId = "72e4b93000be75dd6e367723";
        if (userId != null) {
          return await challengeService.fetchChallengeList(userId);
        } else {
          // TODO: implement rendering of challenges based on group id
          return await challengeService.fetchChallengeList(tempUserId);
        }
      }, () async {
        if (!mounted) return;
        setState(() {
          _challengeModelList = challengeService.challengeModelList;
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    _loadChallengeList(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Heading(
        title: "Challenges",
        actions: [
          if (widget.savingGroupId != null || widget.budgetGroupId != null)
            IconButton(
                onPressed: () {}, icon: const Icon(FontAwesomeIcons.plus)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          
          children: [
            Text(
              "Embrace the challenge, for within it lies the opportunity to discover your true potential and ignite the fire within",
              maxLines: 3,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            (isLoading)
                ? const CircularProgressIndicator()
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListView.builder(
                        itemCount: _challengeModelList!.length,
                        itemBuilder: (context, index) {
                          final challenge = _challengeModelList![index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ChallengeCard(challengeModel: challenge),
                          );
                        },
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
