import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/summary_user_model.dart';
import 'package:tymesavingfrontend/services/invitation_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key, required this.groupId, required this.groupType});

  final String groupType;
  final String groupId;

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  SummaryUser? user;
  bool isLoading = true;

  @override
  void initState() {
    
    super.initState();
  }

  Future<void> _sendInvite(String userId) async {
    Future.microtask(() async {
      await handleMainPageApi(context, () async {
        return await Provider.of<InvitationService>(context,
                listen: false)
          .sendInvitationQR("Join our group now!", 
          widget.groupType,
          widget.groupId, 
          userId);
      }, () async {
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => GroupPendingInvitationPage(
        //           groupId: groupId, type: type),
        //     ),
        //     (route) => false);
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
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          
          if(image != null) {
            final String barCodeValue = barcodes.first.rawValue ?? "Unknown QR code";
            _fetchUserData(barCodeValue);
            
          }
        },
      )
    );
  }

  void _showAcceptDeclinePrompt(BuildContext context, 
  _QRScanPageState state,) async {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.6,
            child: isLoading ? 
            const Center(child: CircularProgressIndicator()) :
            Column(
              children: [
                Text("Invite user $AboutDialog(){user!.fullname}"),
                Text("with username: ${user!.username}"),
                Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text(
                        "Accept",
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
                        "Decline",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              ],
            )
          ),
        );
      }
    );
  }
}