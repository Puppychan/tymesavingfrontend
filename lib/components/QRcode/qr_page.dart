import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  late String userId;
  User? user;

  @override
  void initState() {
    userId = Provider.of<AuthService>(context, listen: false).user!.id;
    user = Provider.of<AuthService>(context, listen: false).user!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const Heading(
        title: "",
        showBackButton: true,
        showHomeButton: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Scan to invite this user', 
            style: textTheme.bodyLarge,),
            Text(user!.fullname.toUpperCase(), 
            style: textTheme.headlineMedium!.copyWith(color: colorScheme.primary),),
            Text(user!.username, 
            style: textTheme.bodyLarge,),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
              child: Card(
                elevation: 8.0,  
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), 
                ),
                shadowColor: colorScheme.shadow, 
                color: Colors.white,  
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),  
                  child: Center(
                    child: QrImageView(
                      data: userId,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}