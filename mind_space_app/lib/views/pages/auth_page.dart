import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../views/widgets/alertBoxWidget/alertBoxWidget.dart';
import '../../views/widgets/uploadPhoto/uploadPhoto.dart';

import '../../controller/auth_user_controller.dart';
import '../dialogs/dialogs.dart';

// in order to provide responsive text size using textScaleFactor property
class TextScaleFactorForHeading {
  static getTextScale(BuildContext context, {double maxScaleExtent = 3}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxScaleExtent;
    return max(1, min(val, maxScaleExtent));
  }
}

class TextScaleFactorForNormalText {
  static getTextScale(BuildContext context, {double maxScaleExtent = 1.5}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxScaleExtent;
    return max(1, min(val, maxScaleExtent));
  }
}

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final controller = Get.put(AuthUserController());
  final GlobalKey<FormState> _formKey = GlobalKey();

  double responsiveFontSize = 16;

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  RxBool isPasswordVisible = false.obs;
  RxBool _isLogin = false.obs;
  RxBool isActiveSubmitButton = false.obs;

  XFile? _pickedImage; // picked user profile pic

  void isValidDetails() {
    final isValid = _formKey.currentState!.validate();
    isValid ? isActiveSubmitButton.value = true : false;
  }

  void googleUserSignUP(BuildContext ctx) {
    print('calling signin now ...');
    controller.googleUserSignUp().catchError((error) {
      showDialog(
        context: ctx,
        builder: (_) {
          return AlertBoxWidget(error);
        },
      );
    });
  }

  void onSubmitted() {
    FocusScope.of(Get.context!).unfocus();

    _formKey.currentState!.save();

    if (_pickedImage == null && !_isLogin.value) {
      // not registered user and also user dp picked null then alert user
      showDialog(
        context: Get.context!,
        builder: (_) {
          return AlertBoxWidget(Dialogs.UPLOAD_IMAGE_REQUEST);
        },
      );
    } else {
      // picked image not null
      XFile? userDp;
      if (!_isLogin.value) {
        // if not logging in store picked image else send null image if phone no login
        userDp = _pickedImage as XFile;
      }
      controller
          .authUser(
              _userEmail.trim(),
              _userName.trim(),
              _userPassword.trim(),
              _isLogin.value,
              userDp) // calling provider function to sign user in
          .catchError(
        (error) {
          showDialog(
            context: Get.context!,
            builder: (_) {
              return AlertBoxWidget(error);
            },
          );
        },
      );
    }
  }

  void imagePicker(XFile? image) {
    _pickedImage = image; // storing picked image in variable
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return Center(
          child: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.2),
            height: screenWidth * 0.8,
            width: screenHeight * 0.8,
            child: Column(
              children: [
                // design

                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Text(
                      'Sign in to MindSpace',
                      textAlign: TextAlign.start,
                      textScaleFactor:
                          TextScaleFactorForHeading.getTextScale(context),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: 25),

                Container(
                  child: Form(
                    key: _formKey,
                    onChanged: isValidDetails,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //dont take as much space as possible but as minimum as needed

                      children: <Widget>[
                        if (!_isLogin.value)
                          // registering user so upload image section else not
                          UploadImage(imagePicker),
                        TextFormField(
                          style: Theme.of(context).textTheme.displaySmall,
                          cursorColor: Theme.of(context).primaryColor,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return Dialogs.INVALID_EMAIL;
                            }
                            return null;
                          },
                          key: const ValueKey('email'),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                              left: 16,
                              right: 16,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            isDense: true,
                            // to size the textformfield dont use sizedBox, use contentpadding to give padding to top and bottom and isDense: true,
                            // by default its false, it means textformfield should take smaller space than default

                            focusColor: Theme.of(context).primaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            hintText: 'youremail@gmail.com',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          onSaved: (value) {
                            _userEmail = value as String;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        if (!_isLogin.value)
                          TextFormField(
                            style: Theme.of(context).textTheme.displaySmall,
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return Dialogs.WRONG_USERNAME;
                              }

                              return null;
                            },
                            key: const ValueKey('Name'),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 16, top: 15, bottom: 15, right: 16),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              isDense: true,
                              focusColor: Theme.of(context).primaryColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              hintText: 'Your Name',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            onSaved: (value) {
                              _userName = value as String;
                            },
                          ),
                        SizedBox(
                          height: _isLogin.value ? 0 : 5,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.displaySmall,
                          cursorColor: Theme.of(context).primaryColor,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return Dialogs.WRONG_PASSWORD_STRUCT;
                            }
                            return null;
                          },
                          key: const ValueKey('password'),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                isPasswordVisible.value =
                                    !isPasswordVisible.value;
                              },
                              icon: isPasswordVisible.value
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 16, top: 15, bottom: 15, right: 16),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusColor: Theme.of(context).primaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            isDense: true,
                            hintText: 'Password (min. 7 characters)',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          obscureText: !isPasswordVisible.value,
                          onSaved: (value) {
                            _userPassword = value as String;
                          },
                        ),
                        SizedBox(height: 15),
                        if (controller.isLoadingAuth.value == true)
                          CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        if (controller.isLoadingAuth.value == false)
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                isActiveSubmitButton.value
                                    ? onSubmitted()
                                    : null;
                              },
                              style: ButtonStyle(
                                elevation: const MaterialStatePropertyAll(0),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                backgroundColor: MaterialStatePropertyAll(
                                    isActiveSubmitButton.value
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade200),
                              ),
                              child: Text(
                                _isLogin.value ? 'LogIn' : 'SignUp',
                                style: isActiveSubmitButton.value
                                    ? TextStyle(color: Colors.white)
                                    : TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                _isLogin.value
                                    ? 'Dont\'t have an account ? '
                                    : 'Already have an account ?',
                                softWrap: true,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                _isLogin.value = !_isLogin.value;
                                developer.log(_isLogin.value.toString());
                              },
                              child: Text(_isLogin.value ? 'Register' : 'LogIn',
                                  style: TextStyle()),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Divider(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.01),
                              child: Text(
                                "or",
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Divider(color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        controller.isGoogleLoadingAuth.value
                            ? CircularProgressIndicator(
                              strokeWidth: 4,
                              color: Colors.green,
                            )
                            : Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(25)),
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // functio to call google signup
                                    googleUserSignUP(context);
                                  },
                                  style: ButtonStyle(
                                    elevation:
                                        const MaterialStatePropertyAll(0),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white),
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: Get.width * 0.02),
                                            child: Image.asset(
                                              'assets/images/google_sign_in.png',
                                              height: 18,
                                              width: 18,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Sign Up with Google',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
