import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/services/TournamentService.dart';
import 'package:play_tennis/main-services.dart';

class TournamentSearchExtensions {
  static GetTournamentsRequest getBaseRequest(
    SearchTournamentsInternalRequest model,
  ) {
    return GetTournamentsRequest(
      openForParticipantsJoining: null,
      activityStatus: TournamentActivityStatus.Active,
      showMine: null,
      cityId: model.cityId,
      count: model.count,
      offSet: model.offSet,
    );
  }

  static GetTournamentsRequest getActiveTournamentsRequest(
      SearchTournamentsInternalRequest model) {
    var activeRequest = getBaseRequest(model);

    activeRequest.activityStatus = TournamentActivityStatus.Active;

    return activeRequest;
  }

  static GetTournamentsRequest getFinishedTournamentsRequest(
      SearchTournamentsInternalRequest model) {
    var finishedRequest = getBaseRequest(model);
    finishedRequest.activityStatus = TournamentActivityStatus.Finished;

    return finishedRequest;
  }

  static GetTournamentsRequest getOpenedTournamentsRequest(
      SearchTournamentsInternalRequest model) {
    var plannedRequest = getBaseRequest(model);

    plannedRequest.activityStatus = TournamentActivityStatus.Planned;
    plannedRequest.openForParticipantsJoining = true;

    return plannedRequest;
  }

  static GetTournamentsRequest getPlannedTournamentsRequest(
      SearchTournamentsInternalRequest model) {
    var plannedRequest = getBaseRequest(model);

    plannedRequest.activityStatus = TournamentActivityStatus.Planned;
    plannedRequest.openForParticipantsJoining = false;

    return plannedRequest;
  }
}

class SearchTournamentsInternalRequest {
  final String? cityId;
  final int? count;
  final int offSet;

  SearchTournamentsInternalRequest({
    required this.cityId,
    required this.count,
    required this.offSet,
  });
}
