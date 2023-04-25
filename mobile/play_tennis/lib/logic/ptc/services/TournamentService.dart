import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class GetTournamentsRequest {
  late bool? openForParticipantsJoining;
  late String? cityId;
  late TournamentActivityStatus? activityStatus;
  late TournamentDurationType? durationType;
  late bool? showMine;
  late bool useHiddenFilter;
  late bool? hidden;
  late bool? isExternal;
  late int? count;
  late int offSet;

  GetTournamentsRequest({
    required this.openForParticipantsJoining,
    required this.cityId,
    required this.activityStatus,
    required this.durationType,
    required this.showMine,
    required this.useHiddenFilter,
    required this.hidden,
    required this.isExternal,
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
        durationType:
            TournamentDurationTypeDartJsonGenerator.getFromStringOrNull(
                json["durationType"]),
        showMine: json["showMine"],
        useHiddenFilter: json["useHiddenFilter"],
        hidden: json["hidden"],
        isExternal: json["isExternal"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'openForParticipantsJoining': openForParticipantsJoining,
        'cityId': cityId,
        'activityStatus': activityStatus,
        'durationType': durationType,
        'showMine': showMine,
        'useHiddenFilter': useHiddenFilter,
        'hidden': hidden,
        'isExternal': isExternal,
        'count': count,
        'offSet': offSet,
      };
}

enum TournamentActivityStatus { Planned, Active, Finished }

class TournamentActivityStatusDartJsonGenerator {
  static TournamentActivityStatus getFromString(String value) {
    return TournamentActivityStatus.values
        .firstWhere((e) => e.toString() == 'TournamentActivityStatus.$value');
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

enum TournamentDurationType { MultiDay, OneDay }

class TournamentDurationTypeDartJsonGenerator {
  static TournamentDurationType getFromString(String value) {
    return TournamentDurationType.values
        .firstWhere((e) => e.toString() == 'TournamentDurationType.' + value);
  }

  static TournamentDurationType? getFromStringOrNull(String? value) {
    return value == null
        ? null
        : TournamentDurationTypeDartJsonGenerator.getFromString(value);
  }

  static String enumToString(TournamentDurationType value) {
    return value.toString().replaceFirst('TournamentDurationType.', "");
  }
}

class TournamentSimpleModel {
  late String? id;
  late bool openForParticipantsJoining;
  late TournamentActivityStatus activityStatus;
  late TournamentDurationType durationType;
  late String? name;
  late String? description;
  late int maxNumberOfParticipants;
  late int currentNumberOfParticipants;
  late int participationCostRub;
  late bool? genderRestriction;
  late bool isInTournament;
  late String? type;
  late String? cityId;
  late bool isExternal;
  late ExternalTournamentDataModel? external;

  TournamentSimpleModel({
    required this.id,
    required this.openForParticipantsJoining,
    required this.activityStatus,
    required this.durationType,
    required this.name,
    required this.description,
    required this.maxNumberOfParticipants,
    required this.currentNumberOfParticipants,
    required this.participationCostRub,
    required this.genderRestriction,
    required this.isInTournament,
    required this.type,
    required this.cityId,
    required this.isExternal,
    required this.external,
  });

  factory TournamentSimpleModel.fromJson(Map<String, dynamic> json) =>
      TournamentSimpleModel(
        id: json["id"],
        openForParticipantsJoining: json["openForParticipantsJoining"],
        activityStatus: TournamentActivityStatusDartJsonGenerator.getFromString(
            json["activityStatus"]),
        durationType: TournamentDurationTypeDartJsonGenerator.getFromString(
            json["durationType"]),
        name: json["name"],
        description: json["description"],
        maxNumberOfParticipants: json["maxNumberOfParticipants"],
        currentNumberOfParticipants: json["currentNumberOfParticipants"],
        participationCostRub: json["participationCostRub"],
        genderRestriction: json["genderRestriction"],
        isInTournament: json["isInTournament"],
        type: json["type"],
        cityId: json["cityId"],
        isExternal: json["isExternal"],
        external: json["external"] != null
            ? ExternalTournamentDataModel?.fromJson(json["external"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'openForParticipantsJoining': openForParticipantsJoining,
        'activityStatus': activityStatus,
        'durationType': durationType,
        'name': name,
        'description': description,
        'maxNumberOfParticipants': maxNumberOfParticipants,
        'currentNumberOfParticipants': currentNumberOfParticipants,
        'participationCostRub': participationCostRub,
        'genderRestriction': genderRestriction,
        'isInTournament': isInTournament,
        'type': type,
        'cityId': cityId,
        'isExternal': isExternal,
        'external': external?.toJson(),
      };
}

class ExternalTournamentDataModel {
  late bool exists;
  late String? link;
  late String? description;

  ExternalTournamentDataModel({
    required this.exists,
    required this.link,
    required this.description,
  });

  factory ExternalTournamentDataModel.fromJson(Map<String, dynamic> json) =>
      ExternalTournamentDataModel(
        exists: json["exists"],
        link: json["link"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        'exists': exists,
        'link': link,
        'description': description,
      };
}

class TournamentService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/tournament-admin/";
  TournamentService(this.networkService);

  Future<GetListResult<TournamentSimpleModel>> search(
    GetTournamentsRequest model,
    Function(String) onError,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postDataV2(
        '${baseUrl}Get/List', bodyJson, onError);

    try {
      var json = await jsonDecode(responseBody);

      if (json["totalCount"] == null) {
        json["totalCount"] = 0;
      }

      var result = GetListResult(
        totalCount: 0,
        list: List<TournamentSimpleModel>.from(
          json["list"].map((x) => TournamentSimpleModel.fromJson(x)),
        ),
        count: json["count"],
        offSet: json["offSet"],
      );

      return result;
    } catch (e) {
      var result = GetListResult<TournamentSimpleModel>(
        totalCount: 0,
        list: List.empty(),
        count: 0,
        offSet: 0,
      );

      return result;
    }
  }
}
