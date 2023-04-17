import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';

class AppUtils {
  static void tryAndShowMessageIfError(
    Function() someCall,
    BuildContext context,
    String errorMessage,
  ) {
    try {
      someCall();
    } catch (e) {
      BaseApiResponseUtils.showError(context, errorMessage);
    }
  }
}
