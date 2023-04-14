import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/models/cities/CityModel.dart';
import 'package:play_tennis/logic/ptc/models/cities/CountrySimpleModel.dart';
import 'package:play_tennis/logic/ptc/models/cities/SearchCities.dart';
import 'package:play_tennis/logic/ptc/models/cities/SearchCountries.dart';

class CountryService {
  final NetworkService networkService;
  CountryService(this.networkService);

  Future<GetListResult<CountrySimpleModel>> searchCountries(
      SearchCountries model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postData(
        '/api/ptc/dlv/countries/search/cached', bodyJson);

    var json = jsonDecode(responseBody);

    var result = GetListResult(
      totalCount: json["totalCount"],
      list: List<CountrySimpleModel>.from(
        json["list"].map((x) => CountrySimpleModel.fromJson(x)),
      ),
      count: json["count"],
      offSet: json["offSet"],
    );

    return result;
  }

  Future<GetListResult<CityModel>> searchCities(
    SearchCities model,
    Function(String) errorHandler,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postData(
        '/api/ptc/dlv/cities/search/cached', bodyJson);

    try {
      var json = jsonDecode(responseBody);

      var result = GetListResult(
        totalCount: json["totalCount"],
        list: List<CityModel>.from(
          json["list"].map((x) => CityModel.fromJson(x)),
        ),
        count: json["count"],
        offSet: json["offSet"],
      );

      return result;
    } catch (e) {
      errorHandler(e.toString());
      return GetListResult(count: 0, list: [], offSet: 0, totalCount: 0);
    }
  }
}
