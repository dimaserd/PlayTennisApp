import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class ClientNotificationsSearchQueryModel {
  late DateTimeRange? createdOn;
  late bool? read;
  late int? count;
  late int offSet;

  ClientNotificationsSearchQueryModel({
    required this.createdOn,
    required this.read,
    required this.count,
    required this.offSet,
  });

  factory ClientNotificationsSearchQueryModel.fromJson(
          Map<String, dynamic> json) =>
      ClientNotificationsSearchQueryModel(
        createdOn: json["createdOn"] != null
            ? DateTimeRange?.fromJson(json["createdOn"])
            : null,
        read: json["read"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'createdOn': createdOn?.toJson(),
        'read': read,
        'count': count,
        'offSet': offSet,
      };
}

class DateTimeRange {
  late DateTime? min;
  late DateTime? max;

  DateTimeRange({
    required this.min,
    required this.max,
  });

  factory DateTimeRange.fromJson(Map<String, dynamic> json) => DateTimeRange(
        min: json["min"] != null ? DateTime.parse(json["min"]) : null,
        max: json["max"] != null ? DateTime.parse(json["max"]) : null,
      );

  Map<String, dynamic> toJson() => {
        'min': min,
        'max': max,
      };
}

class NotificationModel {
  late String? id;
  late String? title;
  late String? text;
  late String? objectType;
  late String? objectJson;
  late UserNotificationType type;
  late DateTime createdOn;
  late DateTime? readOn;
  late String? userId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.text,
    required this.objectType,
    required this.objectJson,
    required this.type,
    required this.createdOn,
    required this.readOn,
    required this.userId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        text: json["text"],
        objectType: json["objectType"],
        objectJson: json["objectJson"],
        type: UserNotificationTypeDartJsonGenerator.getFromString(json["type"]),
        createdOn: DateTime.parse(json["createdOn"]),
        readOn: json["readOn"] != null ? DateTime.parse(json["readOn"]) : null,
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'text': text,
        'objectType': objectType,
        'objectJson': objectJson,
        'type': type,
        'createdOn': createdOn.toIso8601String(),
        'readOn': readOn,
        'userId': userId,
      };
}

enum UserNotificationType { Success, Info, Warning, Danger, Custom }

class UserNotificationTypeDartJsonGenerator {
  static UserNotificationType getFromString(String value) {
    return UserNotificationType.values
        .firstWhere((e) => e.toString() == 'UserNotificationType.$value');
  }

  static UserNotificationType? getFromStringOrNull(String? value) {
    return value == null
        ? null
        : UserNotificationTypeDartJsonGenerator.getFromString(value);
  }

  static String enumToString(UserNotificationType value) {
    return value.toString().replaceFirst('UserNotificationType.', "");
  }
}

class NotificationService {
  final NetworkService networkService;
  NotificationService(this.networkService);

  Future<GetListResult<NotificationModel>> search(
    ClientNotificationsSearchQueryModel model,
    Function(String) errorHandler,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);
    var response = await networkService.postDataV2(
      '/Api/Notification/Client/Query',
      bodyJson,
      errorHandler,
    );

    try {
      var json = jsonDecode(response);

      var result = GetListResult(
        totalCount: json["totalCount"],
        list: List<NotificationModel>.from(
          json["list"].map((x) => NotificationModel.fromJson(x)),
        ),
        count: json["count"],
        offSet: json["offSet"],
      );

      return result;
    } catch (e) {
      errorHandler(e.toString());
      return GetListResult(totalCount: 0, list: [], count: 0, offSet: 0);
    }
  }
}
