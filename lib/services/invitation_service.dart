// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/common/enum/invitation_status_enum.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/models/invitation/invitation_model.dart';
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

  void setSortOptions(String sortOption, String sortValue) {
    if (sortOption == 'sortGroupId' ||
        sortOption == 'sortGroupType' ||
        sortOption == 'sortStatus') {
      if (sortValue == 'ascending' || sortValue == 'descending') {
        _sortOptions = {..._sortOptions, sortOption: sortValue};
        notifyListeners();
      }
    }
  }

  void setFilterOptions(String filterOption, String filterValue) {
    if ((filterOption == 'getGroupType' &&
            [
              'All',
              InvitationType.budget.toString(),
              InvitationType.savings.toString()
            ].contains(filterValue)) ||
        (filterOption == 'getStatus' &&
            [
              'All',
              InvitationStatus.accepted.toString(),
              InvitationStatus.pending.toString(),
              InvitationStatus.cancelled.toString()
            ].contains(filterValue))) {
      _filterOptions = {..._filterOptions, filterOption: filterValue};
      notifyListeners();
    }
  }

  String _convertOptionsToString(String type) {
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
        "${BackendEndpoints.invitation}/${BackendEndpoints.invitationsGetAll}${_convertOptionsToString("byGroup")}${_assignGroupIdEndpoint(groupId)}");
      // print("Filter options: ${_filterOptions.toString()}");
      // print("Response of fetchInvitationsByGroupId: ${BackendEndpoints.invitation}/${BackendEndpoints.invitationsGetAll}${_convertOptionsToString("byGroup")}${_assignGroupIdEndpoint(groupId)}");

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
        "${BackendEndpoints.invitation}/${BackendEndpoints.invitationsGetByUserId}/$userId${_convertOptionsToString("byUser")}");

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
