import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';

class CheckPointDetails extends StatefulWidget {
  const CheckPointDetails({super.key,required this.checkpointId, required this.challengeId});

  final String checkpointId;
  final String challengeId;
  
  @override
  State<CheckPointDetails> createState() => _CheckPointDetailsState();
}

class _CheckPointDetailsState extends State<CheckPointDetails> {
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(
        title: "Checkpoint detail",
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/checkpoint_background.png', // Path to your image
              fit: BoxFit.cover,
            ),
          ),
          // Card on top
          Center(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Checkpoint Details",
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