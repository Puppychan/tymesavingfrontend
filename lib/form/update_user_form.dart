import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/constant/temp_constant.dart';
import 'package:tymesavingfrontend/common/styles/app_extend_theme.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/images/circle_network_image.dart';
import 'package:tymesavingfrontend/components/common/images/rounded_network_image.dart';
import 'package:tymesavingfrontend/components/common/input/round_text_field.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/models/user_model.dart';
import 'package:tymesavingfrontend/screens/image_upload_page.dart';
import 'package:tymesavingfrontend/services/auth_service.dart';
import 'package:tymesavingfrontend/services/user_service.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';
import 'package:tymesavingfrontend/utils/display_success.dart';
import 'package:tymesavingfrontend/utils/handling_error.dart';
import 'package:tymesavingfrontend/utils/validator.dart';

class UpdateUserForm extends StatefulWidget {
  // const UpdateUserForm({super.key, required this.userInfo});
  const UpdateUserForm({super.key, required this.user});

  // final List<String> userInfo;
  final User? user;

  @override
  UpdateUserState createState() => UpdateUserState();
}

class UpdateUserState extends State<UpdateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  bool isDisableSubmit = true;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.user?.fullname ?? '';
    _usernameController.text = widget.user?.username ?? '';
    _phoneController.text = widget.user?.phone ?? '';
    _gmailController.text = widget.user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddingStyles.pagePadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImageUploadPage(title: "Upload Avatar", uploadDetails: {
                      'confirmFunction': (String imagePath) async {
                        return await Provider.of<UserService>(context, listen: false).uploadUserAvatar(widget.user?.username, imagePath);
                      },
                      'successMessage': 'Avatar uploaded successfully',
                    });
                  }));
                },
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    CustomRoundedAvatar(
                        imagePath: widget.user?.avatar ?? TEMP_AVATAR_IMAGE,
                        size: MediaQuery.of(context).size.width * 0.3),
                    Positioned(
                      right: -25,
                      bottom: -25,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipOval(
                          child: Container(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  12.0), // Adjust padding to ensure the icon fits well
                              child: Icon(FontAwesomeIcons.cameraRetro,
                                  size: 30,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 30),
            RoundTextField(
              validator: Validator.validateFullName,
              placeholder: widget.user?.fullname ?? 'Loading...',
              label: 'Full Name',
              controller: _fullNameController,
            ),
            const SizedBox(
              height: 20,
            ),
            RoundTextField(
              validator: Validator.validateUsername,
              placeholder: widget.user?.username ?? 'Loading...',
              label: 'Username',
              enabled: false,
              controller: _usernameController,
            ),
            const SizedBox(
              height: 20,
            ),
            RoundTextField(
              validator: Validator.validatePhone,
              placeholder: widget.user?.phone ?? 'Loading...',
              label: 'Phone Number',
              controller: _phoneController,
            ),
            const SizedBox(
              height: 20,
            ),
            RoundTextField(
              validator: Validator.validateEmail,
              placeholder: widget.user?.email ?? 'Loading...',
              label: 'E-mail',
              controller: _gmailController,
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              title: 'UPDATE',
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Process form submission
    String fullName = _fullNameController.text;
    String username = _usernameController.text;
    String phone = _phoneController.text;
    String gmail = _gmailController.text;

    if (fullName == widget.user?.fullname &&
        username == widget.user?.username &&
        phone == widget.user?.phone &&
        gmail == widget.user?.email) {
      ErrorDisplay.showErrorToast('No changes detected', context);
      return;
    }

    String? fullNameMessage = Validator.validateFullName(fullName);
    if (fullNameMessage != null) {
      ErrorDisplay.showErrorToast(fullNameMessage, context);
      return;
    }
    String? usernameMessage = Validator.validateUsername(username);
    if (usernameMessage != null) {
      ErrorDisplay.showErrorToast(usernameMessage, context);
      return;
    }
    String? phoneMessage = Validator.validatePhone(phone);
    if (phoneMessage != null) {
      ErrorDisplay.showErrorToast(phoneMessage, context);
      return;
    }
    String? gmailMessage = Validator.validateEmail(gmail);
    if (gmailMessage != null) {
      ErrorDisplay.showErrorToast(gmailMessage, context);
      return;
    }

    await handleMainPageApi(context, () async {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      if (authService.user?.username == widget.user?.username) {
        return await authService.updateCurrentUser(
          context,
          gmail,
          phone,
          fullName,
        );
      }
      return await userService.updateUser(username, gmail, phone, fullName);
    }, () async {
      SuccessDisplay.showSuccessToast('User information updated', context);
      Navigator.pop(context);
    });

    /*
    Code for submitting and linkage with back-end to update user information here
    */
  }
}
