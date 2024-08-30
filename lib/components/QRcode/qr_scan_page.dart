import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/invitation_type_enum.dart';
import 'package:tymesavingfrontend/common/enum/rank_color_enum.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/screens/invitation/group_pending_invitation_page.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/display_warning.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key, required this.groupId, required this.groupTypeString, required this.invitationType});

  final String groupTypeString;
  final String groupId;
  final InvitationType invitationType;

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> with RouteAware{
  SummaryUser? user;
  bool isLoading = true;
  List<Barcode> barcodes = [];
  Uint8List? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future<void> _sendInvite(String userId) async {
    Future.microtask(() async {
      await handleMainPageApi(context, () async {
        return await Provider.of<InvitationService>(context,
                listen: false)
          .sendInvitationQR("Join our group now!", 
          widget.groupTypeString,
          widget.groupId, 
          userId);
      }, () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => GroupPendingInvitationPage(
                  groupId: widget.groupId, type: widget.invitationType),
            ),
            (route) => false);
        SuccessDisplay.showSuccessToast(
            "Invitation sent successfully", context);
      });
    });
  }

  Future<void> _fetchUserData(String userId) async {
    
    await handleMainPageApi(context, () async {
      return await Provider.of<UserService>(context, listen: false)
          .getOtherUserInfo(userId);
    }, () async {
      setState(() {
        user = Provider.of<UserService>(context, listen: false).summaryUser;
        _showAcceptDeclinePrompt(context, this);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Heading(
        title: 'Scan QR',
        showBackButton: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.noDuplicates,
                    returnImage: true,
                  ),
                  onDetect: (capture) {
                    barcodes = capture.barcodes;
                    image = capture.image;
                    if (image != null) {
                      final String barCodeValue = barcodes.first.rawValue ?? "Unknown QR code";
                      _fetchUserData(barCodeValue);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Call this inside check function first, then the fetch function will validate!
  void _showAcceptDeclinePrompt(BuildContext context, 
  _QRScanPageState state,) async {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context).height;
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            height: 450,
            child: isLoading ? 
            const Center(child: CircularProgressIndicator()) :
            Padding(
              padding: EdgeInsets.symmetric(vertical: size * 0.05, horizontal: size * 0.02),
              child: Column(
                children: [
                  Text('Invite to group', style: textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.black.withOpacity(0.2),
                    color: colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user!.avatar!),
                            onBackgroundImageError: (exception, stackTrace) {},
                          ),
                          const SizedBox(height: 10),
                          Text(
                            user!.fullname,
                            style: textTheme.bodyMedium!.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user!.username,
                            style: textTheme.bodyMedium!.copyWith(
                              color: colorScheme.primary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user!.rank,
                            style: textTheme.bodyMedium!.copyWith(
                              color: Rank.getRankColor(user!.rank),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: 
                      SizedBox()
                    ),
                  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Text(
                          "Invite",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          _sendInvite(user!.id);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "Cancel",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            barcodes = [];
                            image = null;
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupPendingInvitationPage(
                                  groupId: widget.groupId, type: widget.invitationType),
                            ),
                            (route) => false);
                          WarningDisplay.showWarningToast('Invitation cancelled, no invitation send!', context);
                        },
                      ),
                    ],
                  ),
                ),
                ],
              ),
            )
          ),
        );
      }
    );
  }
}

