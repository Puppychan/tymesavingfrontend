import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/services/challenge_service.dart';
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
            child: _checkPointModel != null ?
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
                      // _checkPointModel!.name,
                      "test",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    // Add more details here
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