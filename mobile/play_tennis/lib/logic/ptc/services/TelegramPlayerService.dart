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
}
