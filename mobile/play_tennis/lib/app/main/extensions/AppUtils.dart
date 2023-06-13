import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';

class AppUtils {
  static void tryAndShowMessageIfError(
    VoidCallback someCall,
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
