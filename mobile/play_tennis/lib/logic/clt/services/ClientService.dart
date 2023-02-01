import 'dart:convert';
import '../../core/NetworkService.dart';
import '../models/BaseApiResponse.dart';

class ClientService {
  final NetworkService networkService;
  ClientService(this.networkService);

  Future<BaseApiResponse> updatePhoto(int fileId) async {
    var response = await networkService.postData(
        '/api/Client/Avatar/Update?fileId=$fileId', "{}");
    var json = jsonDecode(response);
    return BaseApiResponse.fromJson(json);
  }
}
