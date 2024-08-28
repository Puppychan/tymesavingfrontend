import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tymesavingfrontend/common/enum/form_state_enum.dart';
import 'package:tymesavingfrontend/components/common/images/circle_network_image.dart';
import 'package:tymesavingfrontend/components/common/rounded_icon.dart';
import 'package:tymesavingfrontend/components/full_screen_image.dart';
import 'package:tymesavingfrontend/screens/image_upload_page.dart';
import 'package:tymesavingfrontend/services/multi_page_form_service.dart';

class ImagesUploadingMultiForm extends StatefulWidget {
  final List<String> images;
  final FormStateType formType;
  final bool isEditable;

  const ImagesUploadingMultiForm(
      {super.key,
      required this.images,
      required this.formType,
      required this.isEditable});
  @override
  State<ImagesUploadingMultiForm> createState() =>
      _ImagesUploadingMultiFormState();
}

class _ImagesUploadingMultiFormState extends State<ImagesUploadingMultiForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("TRANSACTION IMAGES",
            style: Theme.of(context).textTheme.titleSmall),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(20),
            child: widget.images.isNotEmpty
                ? Row(
                    children: [
                      addImageWidget(context),
                      ...widget.images.expand(
                        (singleImage) => [
                          const SizedBox(width: 20),
                          resultImageWidget(context, singleImage),
                        ],
                      ),
                    ],
                  )
                : noImageSection()),
      ],
    );
  }

  Widget addImageWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (widget.isEditable == false) {
      return Container();
    }
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ImageUploadPage(
              title: "Transaction Image",
              confirmFunction: (BuildContext context, String imageUrl) {
                Provider.of<FormStateProvider>(context, listen: false)
                    .addElementToListField(
                        "transactionImages", imageUrl, widget.formType);
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
    );
  }

  Widget noImageSection() {
    return Column(
      children: [
        addImageWidget(context),
        const SizedBox(height: 20),
        Text(
            [FormStateType.expense, FormStateType.income]
                    .contains(widget.formType)
                ? "Add images of your transaction here" // if creating new transaction
                : "No transaction image uploaded", // if updating or viewing transaction
            style: Theme.of(context).textTheme.bodyLarge)
      ],
    );
  }

  Widget resultImageWidget(BuildContext context, String singleImage) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(children: [
      InkWell(
        splashColor: colorScheme.tertiary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImage(imageUrl: singleImage),
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
            Provider.of<FormStateProvider>(context, listen: false)
                .removeElementFromListField(
                    "transactionImages", singleImage, widget.formType);
          },
          child: RoundedIcon(
              iconData: Icons.delete,
              iconColor: colorScheme.primary,
              backgroundColor: colorScheme.onPrimary,
              size: 35))
    ]);
  }
}
