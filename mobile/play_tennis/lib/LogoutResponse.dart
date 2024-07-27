class LogoutRespone {
  final bool succeeded;
  final String errorMessage;
  final String errorType;

  LogoutRespone({
      required this.succeeded,
      required this.errorMessage,
      required this.errorType
    });

    factory LogoutRespone.fromJson(Map<String, dynamic> json) {
    return LogoutRespone(
      succeeded: json["succeeded"],
      errorMessage: json["errorMessage"],
      errorType: json["errorType"]
    );
  }
}