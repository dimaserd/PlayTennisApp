import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class FilesService {
  final NetworkService networkService;
  FilesService(this.networkService);

  Future<GenericBaseApiResponse<List<int>>> postFile(File file) async {
    var url = "${networkService.domain}/api/files/uploadfiles/now";
    var request = http.MultipartRequest('POST', Uri.parse(url));

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', file.path);

    request.files.add(multipartFile);

    try {
      var response = await request.send();

      var responseBody = await response.stream.bytesToString();

      var decoded = jsonDecode(responseBody);
      var result = BaseApiResponse.fromJson(decoded);

      var responseObject =
          result.isSucceeded ? getList(decoded) : List<int>.empty();
      return GenericBaseApiResponse(result, responseObject);
    } catch (e) {
      print(e);
      var response = BaseApiResponse(
          isSucceeded: false, message: "Произошла ошибка при отправке файла");
      return GenericBaseApiResponse(response, List<int>.empty());
    }
  }

  List<int> getList(dynamic decoded) {
    return List<int>.from(
        decoded["responseObject"].map((x) => int.parse(x.toString())));
  }
}
