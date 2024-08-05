import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/challenge/challenge_card.dart';

import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key, required this.userId});
  final String userId;
  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  List<ChallengeModel>? _challengeModelList;
  bool isLoading = true;

  Future<void> _loadChallengeList(String? userId) async {
    Future.microtask(() async {
      if(!mounted) return;
      final challengeService = Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.fetchChallengeList(userId!);
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
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
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
            (isLoading) ?
              const CircularProgressIndicator() : 
            Expanded (
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
