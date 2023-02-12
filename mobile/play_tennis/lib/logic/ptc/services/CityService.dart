import 'dart:convert';
import '../../core/NetworkService.dart';
import '../models/cities/PublicTelegramChatForCityModel.dart';

class CityService {
  final NetworkService networkService;
  CityService(this.networkService);

  Future<PublicTelegramChatForCityModel?> getById(
    String id,
    Function(String) onError,
  ) async {
    var response = await networkService.getDataInner(
      '/api/ptc/dlv/cities/$id/city-chat/cached',
      onError,
    );

    if (response == "null") {
      return null;
    }

    var json = jsonDecode(response!);

    return PublicTelegramChatForCityModel.fromJson(json);
  }
}
