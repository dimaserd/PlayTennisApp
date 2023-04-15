import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class TelegramLinkResponse {
  late String? command;

  TelegramLinkResponse({
    required this.command,
  });

  factory TelegramLinkResponse.fromJson(Map<String, dynamic> json) =>
      TelegramLinkResponse(
        command: json["command"],
      );

  Map<String, dynamic> toJson() => {
        'command': command,
      };
}

class PlayerTelegramData {
  late String? playerId;
  late int? telegramUserId;
  late String? telegramUserName;

  PlayerTelegramData({
    required this.playerId,
    required this.telegramUserId,
    required this.telegramUserName,
  });

  factory PlayerTelegramData.fromJson(Map<String, dynamic> json) =>
      PlayerTelegramData(
        playerId: json["playerId"],
        telegramUserId: json["telegramUserId"],
        telegramUserName: json["telegramUserName"],
      );

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'telegramUserId': telegramUserId,
        'telegramUserName': telegramUserName,
      };
}

class TelegramPlayerService {
  final NetworkService networkService;

  TelegramPlayerService(this.networkService);

  Future<GenericBaseApiResponse<TelegramLinkResponse>> createTelegramLink(
      Function(String) onError) async {
    var response = await networkService.postData(
        '/api/ptc/player/telegram/CreateLink', "{}");

    var json = jsonDecode(response);

    var result = BaseApiResponse.fromJson(json);

    return GenericBaseApiResponse(
      result,
      TelegramLinkResponse.fromJson(json["responseObject"]),
    );
  }

  Future<PlayerTelegramData> getTelegramData(
    Function(String) onError,
  ) async {
    var response = await networkService.getDataInner(
      '/api/ptc/player/telegram/GetData',
      onError,
    );

    if (response == null) {
      return PlayerTelegramData(
        playerId: null,
        telegramUserId: null,
        telegramUserName: null,
      );
    }

    try {
      var json = jsonDecode(response);

      return PlayerTelegramData.fromJson(json);
    } catch (e) {
      onError(e.toString());

      return PlayerTelegramData(
        playerId: null,
        telegramUserId: null,
        telegramUserName: null,
      );
    }
  }
}
