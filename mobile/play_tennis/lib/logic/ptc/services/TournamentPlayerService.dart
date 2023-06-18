import 'dart:convert';
import 'package:play_tennis/logic/clt/models/BaseApiResponse.dart';
import 'package:play_tennis/logic/core/NetworkService.dart';

class TournamentJoiningResponse {
  late bool isSucceeded;
  late TournamentJoiningErrorType? errorType;

  TournamentJoiningResponse({
    required this.isSucceeded,
    required this.errorType,
  });

  factory TournamentJoiningResponse.fromJson(Map<String, dynamic> json) =>
      TournamentJoiningResponse(
        isSucceeded: json["isSucceeded"],
        errorType:
            TournamentJoiningErrorTypeDartJsonGenerator.getFromStringOrNull(
                json["errorType"]),
      );

  Map<String, dynamic> toJson() => {
        'isSucceeded': isSucceeded,
        'errorType': errorType,
      };
}

enum TournamentJoiningErrorType {
  IsNotPlayer,
  AccountNotConfirmed,
  TournamentNotFound,
  NoRightsForThisTournament,
  TournamentNotOpenedForJoining,
  MaxNumberOfParticipantsReached,
  AlreadyInTournament,
  OppositeGender,
  NotEnoughMoney,
  SystemError
}

class TournamentJoiningErrorTypeDartJsonGenerator {
  static TournamentJoiningErrorType getFromString(String value) {
    return TournamentJoiningErrorType.values.firstWhere(
        (e) => e.toString() == 'TournamentJoiningErrorType.' + value);
  }

  static TournamentJoiningErrorType? getFromStringOrNull(String? value) {
    return value == null
        ? null
        : TournamentJoiningErrorTypeDartJsonGenerator.getFromString(value);
  }

  static String enumToString(TournamentJoiningErrorType value) {
    return value.toString().replaceFirst('TournamentJoiningErrorType.', "");
  }
}

class TournamentLeavingResponse {
  late bool isSucceeded;
  late TournamentLeavingErrorType? errorType;

  TournamentLeavingResponse({
    required this.isSucceeded,
    required this.errorType,
  });

  factory TournamentLeavingResponse.fromJson(Map<String, dynamic> json) =>
      TournamentLeavingResponse(
        isSucceeded: json["isSucceeded"],
        errorType:
            TournamentLeavingErrorTypeDartJsonGenerator.getFromStringOrNull(
                json["errorType"]),
      );

  Map<String, dynamic> toJson() => {
        'isSucceeded': isSucceeded,
        'errorType': errorType,
      };
}

enum TournamentLeavingErrorType {
  BadModel,
  ActionIsForbidden,
  TournamentNotFound,
  NoRightsForThisTournament,
  TournamentNotOpenedForJoiningAndLeaving,
  AlreadyNotInTournament,
  SystemError
}

class TournamentLeavingErrorTypeDartJsonGenerator {
  static TournamentLeavingErrorType getFromString(String value) {
    return TournamentLeavingErrorType.values
        .firstWhere((e) => e.toString() == 'TournamentLeavingErrorType.$value');
  }

  static TournamentLeavingErrorType? getFromStringOrNull(String? value) {
    return value == null
        ? null
        : TournamentLeavingErrorTypeDartJsonGenerator.getFromString(value);
  }

  static String enumToString(TournamentLeavingErrorType value) {
    return value.toString().replaceFirst('TournamentLeavingErrorType.', "");
  }
}

class TournamentPlayerService {
  final NetworkService networkService;
  final String baseUrl = "/api/ptc/tournament/player/";
  TournamentPlayerService(this.networkService);

  Future<GenericBaseApiResponse<TournamentJoiningResponse>> join(
      String tournamentId) async {
    var responseBody =
        await networkService.postData("${baseUrl}join/$tournamentId", "{}");
    var decoded = jsonDecode(responseBody);

    return GenericBaseApiResponse(
      BaseApiResponse.fromJson(decoded),
      getJoiningInnerData(decoded),
    );
  }

  Future<GenericBaseApiResponse<TournamentLeavingResponse>> leave(
      String tournamentId) async {
    var responseBody =
        await networkService.postData("${baseUrl}leave/$tournamentId", "{}");
    var decoded = jsonDecode(responseBody);

    return GenericBaseApiResponse(
      BaseApiResponse.fromJson(decoded),
      getLeavingInnerData(decoded),
    );
  }

  TournamentJoiningResponse getJoiningInnerData(dynamic decoded) {
    return TournamentJoiningResponse.fromJson(
      decoded["responseObject"],
    );
  }

  TournamentLeavingResponse getLeavingInnerData(dynamic decoded) {
    return TournamentLeavingResponse.fromJson(
      decoded["responseObject"],
    );
  }
}
