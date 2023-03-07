import '../models/game-requests/GameRequestDetailedModel.dart';
import '../models/game-requests/GameRequestSimpleModel.dart';

class GameRequestMappingExtensions {
  static GameRequestSimpleModel map(GameRequestDetailedModel model) {
    return GameRequestSimpleModel(
      id: model.id,
      author: model.author,
      matchDateUtc: model.matchDateUtc,
      description: model.description,
      hasMyRespond: model.hasMyRespond,
      respondsCount: model.respondsCount,
    );
  }
}
