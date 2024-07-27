class BaseApiResponse {
  final bool isSucceeded;
  final String message;

  BaseApiResponse({
    required this.isSucceeded,
    required this.message,
  });

  factory BaseApiResponse.fromJson(Map<String, dynamic> json) {
    return BaseApiResponse(
      isSucceeded: json["isSucceeded"],
      message: json["message"],
    );
  }
}

class GenericBaseApiResponse<T> {
  late bool isSucceeded;
  late String message;
  late T? responseObject;

  GenericBaseApiResponse(
    BaseApiResponse response,
    this.responseObject,
  ) {
    isSucceeded = response.isSucceeded;
    message = response.message;
  }
}

class GetListResult<T> {
  late int totalCount;
  late List<T> list;
  late int? count;
  late int offSet;

  GetListResult({
    required this.totalCount,
    required this.list,
    required this.count,
    required this.offSet,
  });

  static GetListResult<T> fromJson<T>(
          Map<String, dynamic> json, Function<T>(dynamic p) mapper) =>
      GetListResult<T>(
        totalCount: json["totalCount"],
        list: List<T>.from(json["list"].map((x) => mapper(x))),
        count: json["count"],
        offSet: json["offSet"],
      );
}

class SettingsApplication {
  late String? applicationName;
  late String? applicationUrl;
  late String? publicImageUrlFormat;

   SettingsApplication({
    required this.applicationName,
    required this.applicationUrl,
    required this.publicImageUrlFormat
  });

  factory SettingsApplication.fromJson(Map<String, dynamic> json) {
    return SettingsApplication(
      applicationName: json["applicationName"],
      applicationUrl: json["applicationUrl"],
      publicImageUrlFormat: json["publicImageUrlFormat"]
    );
    }
}
