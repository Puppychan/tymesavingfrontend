import 'package:flutter/material.dart';
import 'package:tymesavingfrontend/models/invitation_model.dart';
import 'package:tymesavingfrontend/services/utils/get_backend_endpoint.dart';
import 'package:tymesavingfrontend/services/utils/network_service.dart';

class InvitationService extends ChangeNotifier {
  List<Invitation> _invitations = [];

  List<Invitation> get invitations => _invitations;

  Future<dynamic> fetchInvitations(String userId) async {
    // Fetch invitations from the backend
    final response = await NetworkService.instance.get(
        "${BackendEndpoints.invitation}/${BackendEndpoints.invitationsGetByUserId}/$userId");

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
  }
}
