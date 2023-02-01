import 'dart:convert';
import '../../clt/models/BaseApiResponse.dart';
import '../../core/NetworkService.dart';
import '../models/CityModel.dart';
import '../models/CountrySimpleModel.dart';
import '../models/SearchCities.dart';
import '../models/SearchCountries.dart';

class CountryService {
  final NetworkService networkService;
  CountryService(this.networkService);

  Future<GetListResult<CountrySimpleModel>> searchCountries(
      SearchCountries model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postData(
        '/api/ptc/dlv/countries/search', bodyJson);

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

  Future<GetListResult<CityModel>> searchCities(SearchCities model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('/api/ptc/dlv/cities/search', bodyJson);

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
  }
}
