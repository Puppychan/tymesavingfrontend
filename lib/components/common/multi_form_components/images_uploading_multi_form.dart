import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/images/circle_network_image.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';
import 'package:tymesavingfrontend/components/full_screen_image.dart';
import 'package:tymesavingfrontend/screens/image_upload_page.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';

class ImagesUploadingMultiForm extends StatefulWidget {
  final List<String> images;
  final FormStateType formType;

  const ImagesUploadingMultiForm(
      {super.key, required this.images, required this.formType});
  @override
  State<ImagesUploadingMultiForm> createState() =>
      _ImagesUploadingMultiFormState();
}

class _ImagesUploadingMultiFormState extends State<ImagesUploadingMultiForm> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ImageUploadPage(
                          title: "Transaction Image",
                          confirmFunction:
                              (BuildContext context, String imageUrl) {
                            Provider.of<FormStateProvider>(context,
                                    listen: false)
                                .addElementToListField("transactionImages",
                                    imageUrl, widget.formType);
                            Navigator.pop(context);
                          });
                    }));
                  },
                  child: RoundedIcon(
                    iconData: Icons.camera_alt,
                    iconColor: colorScheme.primary,
                    backgroundColor: colorScheme.onPrimary,
                    size: 50,
                  ),
                ),
                ...widget.images.expand(
                  (singleImage) => [
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        InkWell(
                          splashColor: colorScheme.tertiary,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullScreenImage(imageUrl: singleImage),
                              ),
                            );
                          },
                          child: CustomCircleImage(
                              imagePath: singleImage,
                              radius: MediaQuery.of(context).size.width * 0.12),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                            onTap: () {
                              Provider.of<FormStateProvider>(context,
                                    listen: false)
                                .removeElementFromListField("transactionImages",
                                    singleImage, widget.formType);
                            },
                            child: RoundedIcon(
                                iconData: Icons.delete,
                                iconColor: colorScheme.primary,
                                backgroundColor: colorScheme.onPrimary,
                                size: 35))
                      ],
                    )
                  ],
                ),
              ],
            ))
      ],
    );
  }
}
