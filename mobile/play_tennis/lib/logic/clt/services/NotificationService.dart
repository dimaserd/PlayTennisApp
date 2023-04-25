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

class NotificationService {
  final NetworkService networkService;
  NotificationService(this.networkService);

  Future<BaseApiResponse> updatePhoto(
    ClientNotificationsSearchQueryModel model,
    Function(String) onError,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);
    var response = await networkService.postDataV2(
      '/Api/Notification/Client/Query',
      bodyJson,
      onError,
    );
    var json = jsonDecode(response);
    return BaseApiResponse.fromJson(json);
  }
}
