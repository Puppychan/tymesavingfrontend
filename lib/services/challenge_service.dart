import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/models/group_saving_model.dart';
import 'package:tymesavingfrontend/models/reward_model.dart';
import 'package:tymesavingfrontend/models/summary_group_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';
import 'package:tymesavingfrontend/models/transaction_model.dart';

class ChallengeService extends ChangeNotifier {
  ChallengeModel? _challengeModel;
  CheckPointModel? _checkPointModel;
  RewardModel? _rewardModel;
  
  ChallengeModel? get challengeModel => _challengeModel;
  CheckPointModel? get checkPointModel => _checkPointModel;
  RewardModel? get rewardModel => _rewardModel;

  Future<dynamic> fetchChallengeDetails(String? challengeId, {String? name, CancelToken? cancelToken}) async {
    String endpoint =
        "${BackendEndpoints.challengeById}/$challengeId";

    debugPrint(endpoint);

    if (name != null) {
      endpoint += "?name=$name";
    }

    final response = await NetworkService.instance.get(endpoint, cancelToken: cancelToken);
    if (response['response'] != null && response['statusCode'] == 200 ) {
      final responseData = response['response'];
      _challengeModel = ChallengeModel.fromMap(responseData);
      notifyListeners();
    }
    debugPrint(response);
    return response;
  }
}