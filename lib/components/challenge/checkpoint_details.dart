import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class CheckPointDetails extends StatefulWidget {
  const CheckPointDetails({super.key,required this.checkpointId, required this.challengeId});

  final String checkpointId;
  final String challengeId;
  
  @override
  State<CheckPointDetails> createState() => _CheckPointDetailsState();
}

class _CheckPointDetailsState extends State<CheckPointDetails> {
  CheckPointModel? _checkPointModel;
  SummaryUser? _challengeOwner;
  String? createDateFormatted;
  String? endDateFormatted;

  bool _isDisplayRestDescription = false;
  bool isLoading = true;

  Future<void> _loadCheckPoint () async {
    Future.microtask(() async {
      if(!mounted) return;
      final challengeService = Provider.of<ChallengeService>(context, listen: false);
      await handleMainPageApi(context, () async {
        return await challengeService.fetchCheckpointDetails(widget.challengeId, widget.checkpointId);
      }, () async {
        if (!mounted) return;
      });
      setState(() {
        _checkPointModel = challengeService.checkPointModel;
        createDateFormatted = formatDate(DateTime.parse(_checkPointModel!.startDate));
        endDateFormatted = formatDate(DateTime.parse(_checkPointModel!.endDate));
      });
      await _loadUser(_checkPointModel?.createdBy);
    });
  }

  Future<void> _loadUser(String? userId) async {
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
    await _loadCheckPoint();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  String formatDate(DateTime date){
    String formattedDate = DateFormat('MMMM d, y').format(date);
    return formattedDate;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(
        title: "",
        showBackButton: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/checkpoint_background.png', // Path to your image
              fit: BoxFit.cover,
            ),
          ),
          // I stacked this on top of the background image
          Center(
            child: isLoading ?
            const Center(child: CircularProgressIndicator()) :
            Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _checkPointModel!.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Checkpoint by', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 10,),
                            Text('Start on', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 10,),
                            Text('End on', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 10,),
                            Text('Milestone amount', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_challengeOwner!.fullname, style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 10,),
                            Text(createDateFormatted ?? '', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 10,),
                            Text(endDateFormatted ?? '', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 10,),
                            Text(formatAmountToVnd(_checkPointModel!.checkPointValue), style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("Description", style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 20),
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
                                  _checkPointModel!.description,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}