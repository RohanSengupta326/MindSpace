import '../../../controller/auth_user_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../dialogs/dialogs.dart';

class UploadImage extends StatefulWidget {
  final void Function(XFile? image) imagePicker;
  UploadImage(this.imagePicker);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final AuthUserController controller = Get.find();
  XFile? _pickedImage;

  void uplaodImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? dp = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(
      () {
        _pickedImage = dp;
      },
    );
    widget.imagePicker(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: _pickedImage != null
              ? FileImage(
                  // image provider type : File
                  File(_pickedImage!.path),
                )
              : controller.currentUserData.isNotEmpty &&
                      controller.currentUserData[0].dpUrl != ''
                  ? NetworkImage(controller.currentUserData[0].dpUrl)
                  : const AssetImage('assets/images/userdp.jpg')
                      as ImageProvider<Object>,
        ),
        TextButton.icon(
          onPressed: uplaodImage,
          icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
          label: Text(Dialogs.UPLOAD_IMAGE_REQUEST,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              )),
        ),
      ],
    );
  }
}
