import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

void naviPushAndRemoveUntil(context, {required Widget widgetName}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widgetName),
    (route) => false,
  );
}

void naviPush(context, {required Widget widgetName}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widgetName),
  );
}

Widget leadingIconButton(
        {required VoidCallback onPressed, Color colIcon = Colors.black}) =>
    IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_back_ios,
        size: 22,
        color: colIcon,
      ),
    );

void showSnakBar(context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

Future<dynamic> customShowDialog(
  BuildContext context, {
  required String title,
  required List<Widget> widgets,
  Color? titleColor,
  List<Widget>? actions,
  MainAxisAlignment? actionsAlignment,
  EdgeInsetsGeometry? actionsPadding,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsets? insetPadding,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        // SettingModel settingModel;
        return AlertDialog(
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: title,
                textColor: titleColor ?? Colors.teal,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                fontSize: 16,
              ),
            ],
          ),
          insetPadding: insetPadding,
          contentPadding: contentPadding,
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.18,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widgets,
            ),
          ),
          actionsPadding: actionsPadding,
          actions: actions,
          actionsAlignment: actionsAlignment,
        );
      });
}

String handleFirebaseException(FirebaseException e) {
  String? messageError;
  switch (e.code) {
    case 'email-already-in-use':
      messageError = "The account already exists for that email.";
      break;
    case 'invalid-email':
      messageError = "The email address is not valid.";
      break;
    case 'invalid-credential':
      messageError =
          "Something is wrong maybe\nthe email address provided is not associated with any user account or the email or password is incorrect.";
      break;
    case 'operation-not-allowed':
      messageError = "Email/password accounts are not enabled.";
      break;
    case 'weak-password':
      messageError = "The password is too weak.";
      break;
    case 'user-disabled':
      messageError = "The user account has been disabled.";
      break;
    case 'user-not-found':
      messageError = "No user found for that email.";
      break;
    case 'wrong-password':
      messageError = "Wrong password provided for that user.";
      break;
    case 'network-request-failed':
      messageError =
          'Network error occurred. Please check your connection and try again.';
      break;
    case 'user-token-expired':
      messageError = 'Your session has expired. Please log in again.';
      break;
    case 'too-many-requests':
      messageError = 'Too many requests. Please try again later.';
      break;

    // Phone authentication-specific errors
    case 'invalid-verification-code':
      messageError =
          "The SMS verification code used is invalid. Please request a new code.";
      break;
    case 'invalid-verification-id':
      messageError =
          "The verification ID used to create the phone auth credential is invalid.";
      break;
    case 'session-expired':
      messageError = "The SMS code has expired. Please request a new code.";
      break;
    case 'quota-exceeded':
      messageError =
          "The SMS quota for this project has been exceeded. Please try again later.";
      break;
    case 'missing-phone-number':
      messageError =
          "The phone number is missing. Please provide a valid phone number.";
      break;
    case 'invalid-phone-number':
      messageError = "The provided phone number is not valid.";
      break;
    case 'app-not-authorized':
      messageError =
          "This app is not authorized to use Firebase Authentication.";
      break;
    case 'captcha-check-failed':
      messageError = "The reCAPTCHA response token is invalid or has expired.";
      break;
    case 'invalid-app-credential':
      messageError =
          "The app verification code used to create the phone auth credential is invalid.";
      break;
    case 'missing-verification-code':
      messageError = "The verification code is missing.";
      break;
    case 'missing-verification-id':
      messageError = "The verification ID is missing.";
      break;
    case 'invalid-message-payload':
      messageError = "The message payload provided is invalid.";
      break;
    case 'invalid-sender':
      messageError = "The sender ID provided for the SMS is invalid.";
      break;
    case 'missing-client-identifier':
      messageError = "The client identifier is missing.";
      break;
    case 'invalid-app-identifier':
      messageError = "The app identifier is not valid.";
      break;
    case 'missing-app-identifier':
      messageError = "The app identifier is missing.";
      break;
    default:
      messageError = "An undefined error occurred.";
  }
  return messageError;
}
