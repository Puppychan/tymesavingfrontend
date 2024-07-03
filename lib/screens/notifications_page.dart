import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/invitation_model.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // TODO: Replace this with actual data from the backend
  // final List<Invitation> invitations = [
  //   Invitation.fromMap({
  //     '_id': '1',
  //     'code': 'ABC123',
  //     'description': 'Join our budget group for fun savings!',
  //     'type': 'SharedBudget',
  //     'groupId': '507f1f77bcf86cd799439011',
  //     'users': ['user1@example.com', 'user2@example.com'],
  //     'cancelledUsers': [],
  //   }),
  //   Invitation.fromMap({
  //     '_id': '2',
  //     'code': 'XYZ789',
  //     'description': 'Be part of our group saving for a grand vacation!',
  //     'type': 'GroupSaving',
  //     'groupId': '507f1f77bcf86cd799439012',
  //     'users': ['user3@example.com', 'user4@example.com'],
  //     'cancelledUsers': ['user5@example.com'],
  //   }),
  // ];

  User? _user;

  void _fetchInvitations() {
    Future.microtask(() async {
      if (!mounted) return;

      setState(
        () {
          _user = Provider.of<AuthService>(context, listen: false).user;
        },
      );

      // Fetch invitations from the backend
      await handleMainPageApi(context, () async {
        final intivationService =
            Provider.of<InvitationService>(context, listen: false);
        return await intivationService.fetchInvitations(_user?.id ?? "");
      }, () async {});
    });
  }

  @override
  void initState() {
    _fetchInvitations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const Heading(
        title: "Your Invitations",
        showBackButton: true,
      ),
      body: Consumer<InvitationService>(
        builder: (context, invitationService, child) {
          final invitations = invitationService.invitations;
          return invitations.length != 0
              ? ListView.builder(
                  padding: AppPaddingStyles.pagePadding,
                  itemCount: invitations.length,
                  itemBuilder: (context, index) {
                    final invitation = invitations[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // TODO: Replace this with group name
                                "Invite from ${invitation.groupId}",
                                style: textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                invitation.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Handle accept action
                                    },
                                    child: Text('Accept',
                                        style: textTheme.bodyMedium!.copyWith(
                                            color: colorScheme.success)),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        // Handle decline action
                                      },
                                      child: Text(
                                        'Decline',
                                        style: textTheme.bodyMedium!.copyWith(
                                            color: colorScheme.secondary),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(invitation.code,
                                  style: textTheme.bodyLarge!.copyWith(
                                    color: colorScheme.quaternary,
                                  )),
                              const SizedBox(height: 8.0),
                              // CircleAvatar(
                              //   radius: 20,
                              //   backgroundColor: invitation.iconColor,
                              //   child: Icon(
                              //     invitation.icon,
                              //     color: Colors.white,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No invitations found.",
                    style: textTheme.bodyMedium,
                  ),
                );
        },
      ),
    );
  }
}
