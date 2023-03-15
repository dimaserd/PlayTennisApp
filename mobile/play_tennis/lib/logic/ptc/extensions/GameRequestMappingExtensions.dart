import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestDetailedModel.dart';
import 'package:play_tennis/logic/ptc/models/game-requests/GameRequestSimpleModel.dart';

class GameRequestMappingExtensions {
  static GameRequestSimpleModel map(GameRequestDetailedModel model) {
    return GameRequestSimpleModel(
      id: model.id,
      author: model.author,
      matchDateUtc: model.matchDateUtc,
      description: model.description,
      hasMyRespond: model.hasMyRespond,
      respondsCount: model.respondsCount,
      hasMyDeclinedRespond: false,
      hasMyAcceptedRespond: false,
      matchDateString: model.matchDateString,
      toNowDateDescription: model.toNowDateDescription,
    );
  }
}
