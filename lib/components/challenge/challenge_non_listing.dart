import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/challenge/challenge_card.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ChallengeNonListing extends StatefulWidget {
  const ChallengeNonListing({super.key, required this.userId});
  final String userId;
  @override
  State<ChallengeNonListing> createState() => _ChallengeNonListingState();
}

class _ChallengeNonListingState extends State<ChallengeNonListing> {
  List<ChallengeModel>? _challengeModelList;
  bool isLoading = true;
  
  Future<void> _loadChallengeList(String? userId) async {
    Future.microtask(() async {
      if (!mounted) return;
      final challengeService =
          Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.fetchChallengeList(widget.userId);
      }, () async {
        if (!mounted) return;
        setState(() {
          _challengeModelList = challengeService.challengeModelList!
          .where((element) => !element.isPublished).toList();
          isLoading = false;
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
      appBar: const Heading(
        title: "Non-listing challenges",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            Text(
              "Your newly created challenge that is not published",
              maxLines: 3,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            (isLoading)
                ? const CircularProgressIndicator()
                : Expanded(
                  child: SizedBox(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: RefreshIndicator(
                      onRefresh: () => _pullRefresh(),
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
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
  
  Future<void> _pullRefresh() async {
    setState(() {
      isLoading = true;
    });
    _loadChallengeList(widget.userId);
  }
}