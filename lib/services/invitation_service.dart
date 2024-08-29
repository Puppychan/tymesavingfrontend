// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/models/invitation_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class InvitationService extends ChangeNotifier {
  List<Invitation> _invitations = [];
  Map<String, String> _sortOptions = {
    "sortGroupId": 'ascending',
    "sortGroupType": 'ascending',
    "sortStatus": 'ascending',
  };
  Map<String, String> _filterOptions = {
    "getGroupType": 'All',
    "getStatus": 'All',
  };

  List<Invitation> get invitations => _invitations;
  Map<String, String> get sortOptions => _sortOptions;
  Map<String, String> get filterOptions => _filterOptions;

  void setSortOptions(String newSortOption, String sortValue) {
    String sortOption;

    switch (newSortOption) {
      case "Group Id":
        sortOption = 'sortGroupId';
        break;
      case "Group type":
        sortOption = 'sortGroupType';
        break;
      case "Status":
        sortOption = 'sortStatus';
        break;
      default:
        sortOption = '';
    }
    if (_sortOptions.keys.contains(sortOption)) {
      if (sortValue == 'ascending' || sortValue == 'descending') {
        _sortOptions = {..._sortOptions, sortOption: sortValue};
        notifyListeners();
      }
    }
  }

  String convertSortOptionToString(String sortOption) {
    // Convert sort option to readable string to display in the UI
    switch (sortOption) {
      case 'sortGroupId':
        return "Group Id";
      case 'sortGroupType':
        return "Group type";
      case 'sortStatus':
        return "Status";
      default:
        return "";
    }
  }

  void setFilterOptions(String filterOption, String filterValue) {
    if ((filterOption == 'getGroupType' &&
            InvitationType.list.contains(filterValue)) ||
        (filterOption == 'getStatus' &&
            InvitationStatus.list.contains(filterValue))) {
      _filterOptions = {..._filterOptions, filterOption: filterValue};
      notifyListeners();
    }
  }

  String _convertOptionsToParams(String type) {
    String returnParams = "?sortGroupId=${_sortOptions['sortGroupId']}"
        "&sortGroupType=${_sortOptions['sortGroupType']}"
        "&sortStatus=${_sortOptions['sortStatus']}";

    // eliminate if filter option is 'All'
    if (_filterOptions['getGroupType'] != 'All') {
      returnParams += "&getGroupType=${_filterOptions['getGroupType']}";
    }
    if (_filterOptions['getStatus'] != 'All') {
      returnParams += "&getStatus=${_filterOptions['getStatus']}";
    }

    return returnParams;
  }

  String _assignGroupIdEndpoint(String groupId) {
    return groupId.isNotEmpty ? "&getGroupId=$groupId" : "";
  }

  Future<dynamic> fetchInvitationsByGroupId(String groupId) async {
    // Fetch invitations from the backend
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.invitation}/${BackendEndpoints.invitationsGetAll}${_convertOptionsToParams("byGroup")}${_assignGroupIdEndpoint(groupId)}");
    
    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      List<Invitation> invitationList = [];
      if (responseData != [] && responseData != null) {
        for (var invitation in responseData) {
          final tempInvitation = Invitation.fromMap(invitation);
          invitationList.add(tempInvitation);
        }
      }
      _invitations = invitationList;
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> fetchInvitations(String userId) async {
    // Fetch invitations from the backend
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.invitation}/${BackendEndpoints.invitationsGetByUserId}/$userId${_convertOptionsToParams("byUser")}");

    if (response['response'] != null && response['statusCode'] == 200) {
      final responseData = response['response'];
      List<Invitation> invitationList = [];
      if (responseData != [] && responseData != null) {
        for (var invitation in responseData) {
          final tempInvitation = Invitation.fromMap(invitation);
          invitationList.add(tempInvitation);
        }
      }
      _invitations = invitationList;
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> sendInvitation(
    String description,
    InvitationType type,
    String groupId,
    List<dynamic> users,
  ) async {
    List<String> userIds = users.map((user) => user.id as String).toList();
    // final String convertedUserIds = '[' + userIds.join(',') + ']';
    final response =
        await NetworkService.instance.post(BackendEndpoints.invitation, body: {
      "description": description,
      "type": type.toString(),
      "groupId": groupId,
      "users": userIds,
    });
    return response;
  }

  Future<dynamic> acceptInvitation(String userId, String invitationId) async {
    final response = await NetworkService.instance.post(
        "${BackendEndpoints.invitation}/${BackendEndpoints.invitationsAccept}",
        body: {"userId": userId, "invitationId": invitationId});

    if (response['response'] != null && response['statusCode'] == 200) {
      _invitations
          .removeWhere((element) => element.invitationId == invitationId);
      notifyListeners();
    }
    return response;
  }

  Future<dynamic> declineInvitation(String userId, String invitationId) async {
    final response = await NetworkService.instance.post(
        "${BackendEndpoints.invitation}/${BackendEndpoints.invitationsReject}",
        body: {"userId": userId, "invitationId": invitationId});

    if (response['response'] != null && response['statusCode'] == 200) {
      _invitations
          .removeWhere((element) => element.invitationId == invitationId);
      notifyListeners();
    }
    return response;
  }
}
