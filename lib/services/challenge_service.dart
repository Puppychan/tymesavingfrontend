import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/challenge_model.dart';
import 'package:tymesavingfrontend/models/checkpoint_model.dart';
import 'package:tymesavingfrontend/models/reward_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';
import 'package:tymesavingfrontend/utils/format_amount.dart';

class ChallengeService extends ChangeNotifier {
  ChallengeModel? _challengeModel;
  CheckPointModel? _checkPointModel;
  RewardModel? _rewardModel;
  ChallengeDetailMemberModel? _challengeDetailMemberModel;
  ChallengeProgress? _challengeProgress;
  List<ChallengeDetailMemberModel>? _challengeDetailMemberModelList;
  List<CheckPointModel>? _checkPointModelList;
  List<ChallengeModel>? _challengeModelList;
  
  ChallengeModel? get challengeModel => _challengeModel;
  CheckPointModel? get checkPointModel => _checkPointModel;
  RewardModel? get rewardModel => _rewardModel;
  ChallengeProgress? get challengeProgress => _challengeProgress;
  ChallengeDetailMemberModel? get challengeDetailMemberModel => _challengeDetailMemberModel;
  List<ChallengeDetailMemberModel>? get challengeDetailMemberModelList => _challengeDetailMemberModelList;
  List<CheckPointModel>? get checkPointModelList => _checkPointModelList;
  List<ChallengeModel>? get challengeModelList => _challengeModelList;

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
        // debugPrint(responseData.toString());
        // Create the ChallengeModel
        _challengeModel = ChallengeModel.fromMap(responseData);
        
        if (responseData['members'] != null && responseData['members'] is List && (responseData['members'] as List).isNotEmpty) {
            _challengeDetailMemberModelList = (responseData['members'] as List<dynamic>)
              .map((memberMap) => ChallengeDetailMemberModel.fromMap(memberMap as Map<String, dynamic>))
              .toList();
          } else {
            _challengeDetailMemberModelList = [];
          }

        if (responseData['checkpoints'] != null && responseData['checkpoints'] is List && (responseData['checkpoints'] as List).isNotEmpty) {
          _checkPointModelList = (responseData['checkpoints'] as List<dynamic>)
          .map((checkpointMap) => CheckPointModel.fromMap(checkpointMap as Map<String, dynamic>))
          .toList();
        } else {
          _checkPointModelList = [];
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

  Future<dynamic> fetchCheckpointDetails(String challengeId, String checkpointId, {String? name, CancelToken? cancelToken}) async {
    String endpoint = "${BackendEndpoints.challenge}/$challengeId/${BackendEndpoints.checkpoint}/$checkpointId";
    // debugPrint("End point is $endpoint");

    if (name != null) {
      endpoint += "?name=$name";
    }

    try {
      final response = await NetworkService.instance.get(endpoint, cancelToken: cancelToken);
      // debugPrint("API Response: ${response.toString()}");

      if (response != null && response is Map<String, dynamic>) {
        final responseData = response['response'];
        // debugPrint(responseData.toString());
        _checkPointModel = CheckPointModel.fromMap(responseData);
        _rewardModel = RewardModel.fromMap(responseData['rewardDetails'] as Map<String, dynamic>);
      } else {
        debugPrint("Unexpected response format: $response");
      }
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint("Error fetching challenge details: $e");
      rethrow; // Rethrow the error after logging it
    }
  }

  Future<dynamic> fetchChallengeList(String userId, 
  {String? name, String? sortName, String? sortCreateDate, String? pageNo, CancelToken? cancelToken}) async {
    String endpoint = "${BackendEndpoints.challenge}/${BackendEndpoints.challengeByUser}/$userId";
    // debugPrint("End point is $endpoint");
    try {
      final response = await NetworkService.instance.get(endpoint, queryParameters: {
        'name': name,
        'sortCreatedDate': sortCreateDate,
        'sortName': sortName,
      });
      // debugPrint("API Response: ${response.toString()}");
      if (response != null && response is Map<String, dynamic>) {
        final responseData = response['response'];
        _challengeModelList = (responseData as List<dynamic>)
        .map((challengeMap) => ChallengeModel.fromMap(challengeMap as Map<String, dynamic>))
        .toList();

      } else {
        debugPrint("Unexpected response format: $response");
      }
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint("Error fetching challenge details: $e");
      rethrow; // Rethrow the error after logging it
    }
  }

  Future<dynamic> fetchChallengeProgress(String challengeId, String userId 
  ) async {
    String endpoint = "${BackendEndpoints.challenge}/$challengeId/${BackendEndpoints.challengeProgress}/$userId";
    // debugPrint("End point is $endpoint");

    try {
      final response = await NetworkService.instance.get(endpoint, queryParameters: {
      });
      // debugPrint("API Response: ${response.toString()}");
      if (response != null && response is Map<String, dynamic>) {
        final responseData = response['response'];
        _challengeProgress = ChallengeProgress.fromMap(responseData['memberProgress'][0]);
      } else {
        debugPrint("Unexpected response format: $response");
      }
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint("Error fetching challenge details: $e");
      rethrow; // Rethrow the error after logging it
    }
  }

  Future<dynamic> createChallenge(
    String name, String description, String category, String scope, String groupId, String startDate, String endDate,
  )async {
    String endpoint = BackendEndpoints.challenge;
    debugPrint("End point is $endpoint");

    try {
      String groupType;
      if (scope == 'BudgetGroup'){
        groupType = 'budgetGroupId';
      } else {
        groupType = 'savingGroupId';
      }

      debugPrint('''
        {
          'name': $name,
          'description': $description,
          'category': $category,
          'scope': $scope,
          '$groupType': $groupId,
          'startDate': $startDate,
          'endDate': $endDate,
        }
        ''');
      final response = await NetworkService.instance.post(endpoint, body: {
      'name' : name,
      'description': description,
      'category': category,
      'scope': scope,
      groupType: groupId,
      'startDate': startDate,
      'endDate': endDate,
      });
      final responseData = response['response'] as Map<String, dynamic>;
      _challengeModel = ChallengeModel.fromMap(responseData);

      notifyListeners();
      return response;
    } catch (e) {
      debugPrint("Error creating challenge: $e");
    }

  }

  Future<dynamic> createMileStone(
    String challengeId,
    String name, 
    String value, 
    String startDate, 
    String endDate,
    int checkpointValue,
  )async {
    String endpoint = '${BackendEndpoints.challenge}/$challengeId/${BackendEndpoints.checkpoint}';
    debugPrint("End point is $endpoint");

    try {
      final response = await NetworkService.instance.post(endpoint, body: [{
          'name' : name,
          'checkpointValue': convertFormattedAmountToNumber(value),
          'startDate': startDate,
          'endDate': endDate,
          'reward': {
            'name': 'Reward for $name',
            'prize': [
              {
                'category': 'Point',
                'value': checkpointValue
              }
            ]
          }
        }]
      );
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint("Error creating challenge: $e");
    }
  }

  Future<dynamic> deleteChallenge(String challengeId,)async {
    String endpoint = '${BackendEndpoints.challenge}/$challengeId';
    debugPrint("End point is $endpoint");
    try {
      final response = await NetworkService.instance.delete(endpoint);
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint("Error creating challenge: $e");
    }
  }

  Future<dynamic> deleteCheckPoint(String challengeId, String checkpointId)async {
    String endpoint = '${BackendEndpoints.challenge}/$challengeId/${BackendEndpoints.checkpoint}/$checkpointId';
    debugPrint("End point is $endpoint");
    try {
      final response = await NetworkService.instance.delete(endpoint);
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint("Error creating challenge: $e");
    }
  }
}