import 'package:flutteraudioplayer/data/model/AudioPlayerModel.dart';

abstract class AudioPlayerRepository {
  Future<AudioPlayerModel> getById(String audioPlayerId);
  Future<List<AudioPlayerModel>> getAll();

  Future<List<AudioPlayerModel>> updateModel(AudioPlayerModel updatedModel);
  Future<List<AudioPlayerModel>> updateAllModels(List<AudioPlayerModel> updatedList);
}