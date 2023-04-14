import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class SearchTrainerCardsRequest {
  late String? q;
  late String? cityId;
  late int? count;
  late int offSet;

  SearchTrainerCardsRequest({
    required this.q,
    required this.cityId,
    required this.count,
    required this.offSet,
  });

  factory SearchTrainerCardsRequest.fromJson(Map<String, dynamic> json) =>
      SearchTrainerCardsRequest(
        q: json["q"],
        cityId: json["cityId"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'q': q,
        'cityId': cityId,
        'count': count,
        'offSet': offSet,
      };
}

class TrainerCardSimpleModel {
  late String? id;
  late String? name;
  late String? surname;
  late String? patronymic;
  late String? email;
  late bool noEmail;
  late String? phoneNumber;
  late bool sex;
  late String? description;

  TrainerCardSimpleModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.email,
    required this.noEmail,
    required this.phoneNumber,
    required this.sex,
    required this.description,
  });

  factory TrainerCardSimpleModel.fromJson(Map<String, dynamic> json) =>
      TrainerCardSimpleModel(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        patronymic: json["patronymic"],
        email: json["email"],
        noEmail: json["noEmail"],
        phoneNumber: json["phoneNumber"],
        sex: json["sex"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'surname': surname,
        'patronymic': patronymic,
        'email': email,
        'noEmail': noEmail,
        'phoneNumber': phoneNumber,
        'sex': sex,
        'description': description,
      };
}

class TrainerCardService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/trainer-card/";
  TrainerCardService(this.networkService);

  Future<GetListResult<TrainerCardSimpleModel>> search(
      SearchTrainerCardsRequest model, Function(String) errorHandler) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postDataV2(
        '${baseUrl}search', bodyJson, errorHandler);

    try {
      var json = jsonDecode(responseBody);

      var result = GetListResult(
        totalCount: json["totalCount"],
        list: List<TrainerCardSimpleModel>.from(
          json["list"].map((x) => TrainerCardSimpleModel.fromJson(x)),
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
