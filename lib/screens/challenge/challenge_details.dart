import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ChallengeDetails extends StatefulWidget {
  const ChallengeDetails({super.key});

  @override
  State<ChallengeDetails> createState() => _ChallengeDetailsState();
}

class _ChallengeDetailsState extends State<ChallengeDetails> {
  ChallengeModel? _challengeModel;

  bool _isDisplayRestDescription = false;


  Future<void> _loadChallenge(String? challengeId) async {
    Future.microtask(() async {
      if(!mounted) return;
      final challengeService = Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.fetchChallengeDetails(challengeId);
      }, () async {
        if (!mounted) return;
        setState(() {
         _challengeModel = challengeService.challengeModel;
        });
      });
    });
  }

  @override
  void initState() {
    _loadChallenge('69aa2c6b9b7fbb182d820d30');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const Heading(
        title: "Challenge details",
        showBackButton: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Card.filled(
              color: colorScheme.onPrimary,
              child: Column(
                children: [
                  Text(
                    "/Challenge name/",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "/Category/",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 10,),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(  
                      children: [
                        Text(
                          "By /user/",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Expanded(child: SizedBox(),),
                        Text(
                          "On {dd/mm/yyyy}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    "/Scope/ /BudgetGroupName/",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: InkWell(
                      onTap: () {
                        // Action to view the rest of the description. This could open a dialog, a new page, or expand the text in place.
                        setState(() {
                            _isDisplayRestDescription =
                                !_isDisplayRestDescription;
                          });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
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
                          )
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}