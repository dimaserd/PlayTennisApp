import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';
import 'package:play_tennis/logic/ptc/models/games/TennisSetData.dart';
import 'package:play_tennis/logic/ptc/services/GameService.dart';

class TournamentDetailedModel {
  late String? id;
  late bool openForParticipantsJoining;
  late TournamentActivityStatus activityStatus;
  late TournamentDurationType durationType;
  late String? name;
  late String? description;
  late String? newsHtml;
  late int maxNumberOfParticipants;
  late bool isInTournament;
  late bool? genderRestriction;
  late bool hidden;
  late String? type;
  late String? cityId;
  late int participationCostRub;
  late bool isExternal;
  late ExternalTournamentDataModel? external;
  late List<TournamentEventModel>? events;
  late List<PlayerSimpleModel>? players;

  TournamentDetailedModel({
    required this.id,
    required this.openForParticipantsJoining,
    required this.activityStatus,
    required this.durationType,
    required this.name,
    required this.description,
    required this.newsHtml,
    required this.maxNumberOfParticipants,
    required this.isInTournament,
    required this.genderRestriction,
    required this.hidden,
    required this.type,
    required this.cityId,
    required this.participationCostRub,
    required this.isExternal,
    required this.external,
    required this.events,
    required this.players,
  });

  factory TournamentDetailedModel.fromJson(Map<String, dynamic> json) =>
      TournamentDetailedModel(
        id: json["id"],
        openForParticipantsJoining: json["openForParticipantsJoining"],
        activityStatus: TournamentActivityStatusDartJsonGenerator.getFromString(
            json["activityStatus"]),
        durationType: TournamentDurationTypeDartJsonGenerator.getFromString(
            json["durationType"]),
        name: json["name"],
        description: json["description"],
        newsHtml: json["newsHtml"],
        maxNumberOfParticipants: json["maxNumberOfParticipants"],
        isInTournament: json["isInTournament"],
        genderRestriction: json["genderRestriction"],
        hidden: json["hidden"],
        type: json["type"],
        cityId: json["cityId"],
        participationCostRub: json["participationCostRub"],
        isExternal: json["isExternal"],
        external: json["external"] != null
            ? ExternalTournamentDataModel?.fromJson(json["external"])
            : null,
        events: List<TournamentEventModel>.from(
            json["events"].map((x) => TournamentEventModel.fromJson(x))),
        players: List<PlayerSimpleModel>.from(
            json["players"].map((x) => PlayerSimpleModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'openForParticipantsJoining': openForParticipantsJoining,
        'activityStatus': activityStatus,
        'durationType': durationType,
        'name': name,
        'description': description,
        'newsHtml': newsHtml,
        'maxNumberOfParticipants': maxNumberOfParticipants,
        'isInTournament': isInTournament,
        'genderRestriction': genderRestriction,
        'hidden': hidden,
        'type': type,
        'cityId': cityId,
        'participationCostRub': participationCostRub,
        'isExternal': isExternal,
        'external': external?.toJson(),
        'events': events?.map((e) => e.toJson()).toList(),
        'players': players?.map((e) => e.toJson()).toList(),
      };
}

class TournamentEventModel {
  late String? id;
  late int eventNumberIdentifier;
  late String? gameTypeName;
  late bool isParticipantsDataReady;
  late bool resultConfirmed;
  late bool hasScoreData;
  late String? description;
  late String? scoreDataUpdatedByUserId;
  late List<GamePlayerModel>? players;
  late TennisMatchData? scoreData;
  late DateTime? dateRestrictionUtc;
  late bool canSetScore;
  late int? imageFileId;

  TournamentEventModel({
    required this.id,
    required this.eventNumberIdentifier,
    required this.gameTypeName,
    required this.isParticipantsDataReady,
    required this.resultConfirmed,
    required this.hasScoreData,
    required this.description,
    required this.scoreDataUpdatedByUserId,
    required this.players,
    required this.scoreData,
    required this.dateRestrictionUtc,
    required this.canSetScore,
    required this.imageFileId,
  });

  factory TournamentEventModel.fromJson(Map<String, dynamic> json) =>
      TournamentEventModel(
        id: json["id"],
        eventNumberIdentifier: json["eventNumberIdentifier"],
        gameTypeName: json["gameTypeName"],
        isParticipantsDataReady: json["isParticipantsDataReady"],
        resultConfirmed: json["resultConfirmed"],
        hasScoreData: json["hasScoreData"],
        description: json["description"],
        scoreDataUpdatedByUserId: json["scoreDataUpdatedByUserId"],
        players: List<GamePlayerModel>.from(
            json["players"].map((x) => GamePlayerModel.fromJson(x))),
        scoreData: json["scoreData"] != null
            ? TennisMatchData?.fromJson(json["scoreData"])
            : null,
        dateRestrictionUtc: json["dateRestrictionUtc"] != null
            ? DateTime.parse(json["dateRestrictionUtc"])
            : null,
        canSetScore: json["canSetScore"],
        imageFileId: json["imageFileId"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventNumberIdentifier': eventNumberIdentifier,
        'gameTypeName': gameTypeName,
        'isParticipantsDataReady': isParticipantsDataReady,
        'resultConfirmed': resultConfirmed,
        'hasScoreData': hasScoreData,
        'description': description,
        'scoreDataUpdatedByUserId': scoreDataUpdatedByUserId,
        'players': players?.map((e) => e.toJson()).toList(),
        'scoreData': scoreData?.toJson(),
        'dateRestrictionUtc': dateRestrictionUtc,
        'canSetScore': canSetScore,
        'imageFileId': imageFileId,
      };
}

class GamePlayerModel {
  late String? userId;
  late bool isWinner;

  GamePlayerModel({
    required this.userId,
    required this.isWinner,
  });

  factory GamePlayerModel.fromJson(Map<String, dynamic> json) =>
      GamePlayerModel(
        userId: json["userId"],
        isWinner: json["isWinner"],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'isWinner': isWinner,
      };
}

class GetTournamentsRequest {
  late bool? openForParticipantsJoining;
  late String? cityId;
  late TournamentActivityStatus? activityStatus;
  late bool? showMine;
  late int? count;
  late int offSet;

  GetTournamentsRequest({
    required this.openForParticipantsJoining,
    required this.cityId,
    required this.activityStatus,
    required this.showMine,
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
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'openForParticipantsJoining': openForParticipantsJoining,
        'cityId': cityId,
        'activityStatus': activityStatus != null
            ? TournamentActivityStatusDartJsonGenerator.enumToString(
                activityStatus!)
            : null,
        'showMine': showMine,
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
        .firstWhere((e) => e.toString() == 'TournamentDurationType.$value');
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
  final String baseUrl = "/api/ptc/tournament/query/";
  TournamentService(this.networkService);

  Future<GetListResult<TournamentSimpleModel>> search(
    GetTournamentsRequest model,
    Function(String) onError,
  ) async {
    var map = model.toJson();
    var bodyJson = jsonEncode(map);

    var responseBody = await networkService.postDataV2(
      '${baseUrl}Get/List',
      bodyJson,
      onError,
    );

    try {
      var json = await jsonDecode(responseBody);

      if (json["totalCount"] == null) {
        json["totalCount"] = 0;
      }

      var result = GetListResult(
        totalCount: 0,
        list: List<TournamentSimpleModel>.from(
          json["list"].map(
            (x) => TournamentSimpleModel.fromJson(x),
          ),
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

  Future<TournamentDetailedModel?> getById(
    String id,
    Function(String) errorHandler,
  ) async {
    var response = await networkService.getDataInner(
      '${baseUrl}get/ById/$id',
      errorHandler,
    );

    if (response == "null") {
      return null;
    }

    try {
      var json = jsonDecode(response!);

      return TournamentDetailedModel.fromJson(json);
    } catch (e) {
      errorHandler(e.toString());
      return null;
    }
  }
}
