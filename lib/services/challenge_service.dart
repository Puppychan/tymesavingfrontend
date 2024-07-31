import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/models/group_saving_model.dart';
import 'package:tymesavingfrontend/models/reward_model.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';
import 'package:tymesavingfrontend/screens/challenge/challenge_details.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';

class ChallengeService extends ChangeNotifier {
  ChallengeModel? _challengeModel;
  CheckPointModel? _checkPointModel;
  RewardModel? _rewardModel;
  ChallengeDetailMemberModel? _challengeDetailMemberModel;
  List<ChallengeDetailMemberModel>? _challengeDetailMemberModelList;
  
  ChallengeModel? get challengeModel => _challengeModel;
  CheckPointModel? get checkPointModel => _checkPointModel;
  RewardModel? get rewardModel => _rewardModel;
  ChallengeDetailMemberModel? get challengeDetailMemberModel => _challengeDetailMemberModel;
  List<ChallengeDetailMemberModel>? get challengeDetailMemberModelList => _challengeDetailMemberModelList;

  Future<dynamic> fetchChallengeDetails(String challengeId, {String? name, CancelToken? cancelToken}) async {
  String endpoint = "${BackendEndpoints.challenge}/$challengeId";

  // debugPrint(endpoint);

  if (name != null) {
    endpoint += "?name=$name";
  }

  try {
    final response = await NetworkService.instance.get(endpoint, cancelToken: cancelToken);
    if (response is Map<String, dynamic> && response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'] as Map<String, dynamic>;

      // Create the ChallengeModel
      _challengeModel = ChallengeModel.fromMap(responseData);
      
      if (responseData['members'] != null) {
          _challengeDetailMemberModelList = (responseData['members'] as List<dynamic>)
            .map((memberMap) => ChallengeDetailMemberModel.fromMap(memberMap as Map<String, dynamic>))
            .toList();
        }

      notifyListeners();
    } else {
      debugPrint("Error: Response does not contain the expected structure.");
    }

    // Debug print response using jsonEncode to ensure it's printed as a string
    // debugPrint("DEBUG PRINT FOR SERVICE: ${jsonEncode(response)}");
    return response;

  } catch (e) {
    debugPrint("Error fetching challenge details: $e");
    rethrow; // Rethrow the error after logging it
  }
}
}