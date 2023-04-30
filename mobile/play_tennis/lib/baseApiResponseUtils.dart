import 'package:flutter/material.dart';
import 'logic/clt/models/BaseApiResponse.dart';

class BaseApiResponseUtils {
  static void handleResponse(BuildContext context, BaseApiResponse response) {
    if (response.isSucceeded) {
      showSuccess(context, response.message);
    } else {
      showError(context, response.message);
    }
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}
