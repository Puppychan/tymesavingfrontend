import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/challenge/challenge_details_member.dart';
import 'package:tymesavingfrontend/components/challenge/checkpoint_card.dart';
import 'package:tymesavingfrontend/components/challenge/checkpoint_details.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/button/secondary_button.dart';
import 'package:tymesavingfrontend/form/milestone_create.dart';
import 'package:tymesavingfrontend/main.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/challenge/challenge_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class ChallengeDetails extends StatefulWidget {
  const ChallengeDetails({super.key, required this.challengeId, required this.isForListing});
  final String challengeId;
  final bool isForListing;
  @override
  State<ChallengeDetails> createState() => _ChallengeDetailsState();
}

class _ChallengeDetailsState extends State<ChallengeDetails> with RouteAware{
  ChallengeModel? _challengeModel;
  SummaryUser? _challengeOwner;
  ChallengeProgress? _challengeProgress;
  List<ChallengeDetailMemberModel>? _challengeDetailMemberModelList;
  List<CheckPointModel>? _checkPointModelList;

  bool _isDisplayRestDescription = false;
  bool isLoading = true;
  late User? _currentUser;

  String? createdDate;
  late int _currentStep = 0;
  int _currentProgress = 1;

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
      // debugPrint(_challengeModel!.toString());
      await _loadChallengeUser(_challengeModel?.createdBy);
    });
  }

  Future<void> _deleteChallenge(String? challengeId) async {
    Future.microtask(() async {
      if(!mounted) return;
      final challengeService = Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.deleteChallenge(challengeId!);
      }, () async {
        if (!mounted) return;
      });
    });
  }

  Future<void> _loadChallengeProgress(String? challengeId, String? userId) async {
    Future.microtask(() async {
      if(!mounted) return;
      final challengeService = Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.fetchChallengeProgress(challengeId!, userId!);
      }, () async {
        if (!mounted) return;
        setState(() {
          _challengeProgress = challengeService.challengeProgress;
          // debugPrint(_challengeProgress!.currentProgress.toString());
          _currentProgress = _challengeProgress!.reachedMilestone;

        if (_currentStep >= _checkPointModelList!.length) {
          _currentStep = _checkPointModelList!.length - 1;
        } else {
          _currentStep = 0;
        }
          isLoading = false;
        });
      });
    });
  }

  Future<void> _loadChallengeUser(String? userId) async {
    Future.microtask(() async {
      if(!mounted) return;
      final userService = Provider.of<UserService>(context, listen: false);
      await handleMainPageApi(context, () async {
        // debugPrint("USER ID FOR CHALLENGE IS: $userId");
        return await userService.getOtherUserInfo(userId);
      }, () async {
        if (!mounted) return;
        setState(() {
          _challengeOwner = userService.summaryUser;
        });
      });
      await _loadChallengeProgress(widget.challengeId, _currentUser!.id);
    });
  }

  Future<void> loadData() async {
    await _loadChallenge(widget.challengeId);
  }

  Future<void> loadUser() async {
    Future.microtask(() async {
      if (!mounted) return;
      final authService = Provider.of<AuthService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await authService.getCurrentUserData();
      }, () async {
        setState(() {
          _currentUser = authService.user;
        });
      });
      await loadData();
    });
  }
  @override
    void didPopNext() {
      super.didPopNext();
      isLoading = true;
      loadUser();
      
  }
  @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
    }

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Scaffold(
    backgroundColor: colorScheme.tertiaryContainer,
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: loadData,
          child: CustomScrollView(
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
                  actions: 
                  _currentUser!.id == _challengeModel!.createdBy ?[
                     IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeletePrompt(context),
                    )
                  ]
                  : null
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Card.outlined(
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                  "Belong to",
                                  style: Theme.of(context).textTheme.headlineMedium,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                            Text(
                                  _challengeModel!.groupName,
                                  style: Theme.of(context).textTheme.labelLarge,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                            const SizedBox(height: 10,),
                            Text(
                                  _challengeModel!.name,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
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
                                    "$createdDate",
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    "By ${_challengeOwner!.fullname}",
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
                                    "Milestones",
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                            !widget.isForListing && _checkPointModelList!.length < 5 ?
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                            child: PrimaryButton(title: 'Create milestones', onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MileStoneCreatePage(challengeId: _challengeModel!.id,)));
                            }),)
                            : const SizedBox(height: 10),
                            Text(
                                    "Progress: ${formatAmountToVnd(_challengeProgress!.currentProgress.toDouble())}",
                                    style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            // Stepper for challenge
                            widget.isForListing ?
                            Stepper(
                              currentStep: _currentStep >= _checkPointModelList!.length ? _checkPointModelList!.length - 1 : _currentStep,
                              onStepTapped: (step) => setState(() => _currentStep = step),
                              onStepContinue: _currentProgress > _currentStep ?
                              (){} : null,
                              onStepCancel: () {
                                if (_currentStep > 0) {
                                  setState(() => _currentStep -= 1);
                                }
                              },
                              steps: _buildStep(),
                              controlsBuilder: (BuildContext context, ControlsDetails control){
                                final checkpoint = _checkPointModelList![_currentStep];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.25,
                                        ),
                                        child: SecondaryButton(
                                          title: "Detail", 
                                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return CheckPointDetails(checkpointId: checkpoint.id, challengeId: widget.challengeId);
                                          })),                  
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          :
                          // Vault for stepper to be replace
                              Column(
                                children: _checkPointModelList!.map((checkpoint) {
                                  return CheckPointCard(checkpoint: checkpoint, challengeId: _challengeModel!.id,);
                                }).toList(),
                              ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    if (_challengeDetailMemberModelList != null && _challengeDetailMemberModelList!.isNotEmpty)
                    Card.outlined(
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
                                  height: 350, // Specify the height here
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    itemCount: _challengeDetailMemberModelList!.length,
                                    itemBuilder: (context, index) {
                                      final member = _challengeDetailMemberModelList![index];
                                      return UserCard(
                                        username: member.username,
                                        fullname: member.fullname,
                                        avatar: member.avatar,
                                        rank: member.tymeReward ?? '',
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
        ),
    );
  }
  
  List<Step> _buildStep(){
    if (_checkPointModelList == null || _checkPointModelList!.isEmpty){
      return [];
    }

    return _checkPointModelList!.asMap().entries.map((e) {
      int index = e.key;
      final entry = e.value;
      return Step(
        title: Text("Milestone ${index+1}"),
        subtitle:  Text(entry.name, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.visible,),
        content: Column(
          children: [
            Text(formatAmountToVnd(entry.checkPointValue), style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w500), overflow: TextOverflow.visible,),
          ],
        ),
        isActive: _currentProgress > index ? true : false,
        state: _currentProgress > index ?
        StepState.complete : StepState.indexed
      );
    }).toList();
  }

  void _showDeletePrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Challenge Confirmation', style: Theme.of(context).textTheme.headlineSmall,),
          content: Text('Are you sure you want to delete this challenge?'
          ,style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.visible,),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: Theme.of(context).textTheme.labelLarge,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: Theme.of(context).textTheme.labelLarge,),
              onPressed: () {
                _deleteChallenge(_challengeModel!.id);
                Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => ChallengePage(userId: _currentUser!.id,)),(_) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
