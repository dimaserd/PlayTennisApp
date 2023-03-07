import 'dart:convert';
import 'package:play_tennis/logic/core/NetworkService.dart';
import '../../clt/models/BaseApiResponse.dart';

class GetTournamentsRequest {
  late bool? openForParticipantsJoining;
  late String? cityId;
  late TournamentActivityStatus? activityStatus;
  late bool? showMine;
  late bool useHiddenFilter;
  late bool? hidden;
  late int? count;
  late int offSet;

  GetTournamentsRequest({
    required this.openForParticipantsJoining,
    required this.cityId,
    required this.activityStatus,
    required this.showMine,
    required this.useHiddenFilter,
    required this.hidden,
    required this.count,
    required this.offSet,
  });

  factory GetTournamentsRequest.fromJson(Map<String, dynamic> json) =>
      GetTournamentsRequest(
        openForParticipantsJoining: json["openForParticipantsJoining"],
        cityId: json["cityId"],
        activityStatus:
            TournamentActivityStatusDartJsonGenerator.getFromStringOrNull(
                json["activityStatus"]),
        showMine: json["showMine"],
        useHiddenFilter: json["useHiddenFilter"],
        hidden: json["hidden"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'openForParticipantsJoining': openForParticipantsJoining,
        'cityId': cityId,
        'activityStatus': activityStatus,
        'showMine': showMine,
        'useHiddenFilter': useHiddenFilter,
        'hidden': hidden,
        'count': count,
        'offSet': offSet,
      };
}

class TournamentSimpleModel {
  late String? id;
  late bool openForParticipantsJoining;
  late TournamentActivityStatus activityStatus;
  late String? name;
  late String? description;
  late int maxNumberOfParticipants;
  late int currentNumberOfParticipants;
  late int participationCostRub;
  late bool? genderRestriction;
  late bool isInTournament;
  late String? type;
  late String? cityId;

  TournamentSimpleModel({
    required this.id,
    required this.openForParticipantsJoining,
    required this.activityStatus,
    required this.name,
    required this.description,
    required this.maxNumberOfParticipants,
    required this.currentNumberOfParticipants,
    required this.participationCostRub,
    required this.genderRestriction,
    required this.isInTournament,
    required this.type,
    required this.cityId,
  });

  factory TournamentSimpleModel.fromJson(Map<String, dynamic> json) =>
      TournamentSimpleModel(
        id: json["id"],
        openForParticipantsJoining: json["openForParticipantsJoining"],
        activityStatus: TournamentActivityStatusDartJsonGenerator.getFromString(
            json["activityStatus"]),
        name: json["name"],
        description: json["description"],
        maxNumberOfParticipants: json["maxNumberOfParticipants"],
        currentNumberOfParticipants: json["currentNumberOfParticipants"],
        participationCostRub: json["participationCostRub"],
        genderRestriction: json["genderRestriction"],
        isInTournament: json["isInTournament"],
        type: json["type"],
        cityId: json["cityId"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'openForParticipantsJoining': openForParticipantsJoining,
        'activityStatus': activityStatus,
        'name': name,
        'description': description,
        'maxNumberOfParticipants': maxNumberOfParticipants,
        'currentNumberOfParticipants': currentNumberOfParticipants,
        'participationCostRub': participationCostRub,
        'genderRestriction': genderRestriction,
        'isInTournament': isInTournament,
        'type': type,
        'cityId': cityId,
      };
}

enum TournamentActivityStatus { planned, active, finished }

class TournamentActivityStatusDartJsonGenerator {
  static TournamentActivityStatus getFromString(String value) {
    return TournamentActivityStatus.values.firstWhere(
        (e) => toCSharpString(e) == 'TournamentActivityStatus.$value');
  }

  static String toCSharpString(TournamentActivityStatus e) {
    var s = e.toString();
    return s[0].toUpperCase() + s.substring(1);
  }

  static TournamentActivityStatus? getFromStringOrNull(String? value) {
    return value == null
        ? null
        : TournamentActivityStatusDartJsonGenerator.getFromString(value);
  }

  static String enumToString(TournamentActivityStatus value) {
    return value.toString().replaceFirst('TournamentActivityStatus.', "");
  }
}

class TournamentService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/tournament-admin/";
  TournamentService(this.networkService);

  Future<GetListResult<TournamentSimpleModel>> search(
      GetTournamentsRequest model) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody =
        await networkService.postData('${baseUrl}Get/List', bodyJson);

    var json = jsonDecode(responseBody);

    var result = GetListResult(
      totalCount: json["totalCount"],
      list: List<TournamentSimpleModel>.from(
        json["list"].map((x) => TournamentSimpleModel.fromJson(x)),
      ),
      count: json["count"],
      offSet: json["offSet"],
    );

    return result;
  }
}
