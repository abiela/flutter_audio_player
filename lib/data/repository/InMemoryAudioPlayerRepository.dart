import 'package:flutteraudioplayer/data/model/AudioPlayerModel.dart';

import 'AudioPlayerRepository.dart';

class InMemoryAudioPlayerRepository implements AudioPlayerRepository {

  final List<AudioPlayerModel> audioPlayerModels;

  InMemoryAudioPlayerRepository({this.audioPlayerModels});

  @override
  Future<AudioPlayerModel> getById(String audioPlayerId) {
    return Future.value(audioPlayerModels.firstWhere((model) => model.id == audioPlayerId));
  }

  @override
  Future<List<AudioPlayerModel>> getAll() async {
    return Future.value(audioPlayerModels);
  }


  @override
  Future<List<AudioPlayerModel>> updateModel(AudioPlayerModel updatedModel) {
    audioPlayerModels[audioPlayerModels.indexWhere((element) => element.id == updatedModel.id)] = updatedModel;
    return Future.value(audioPlayerModels);
  }

  @override
  Future<List<AudioPlayerModel>> updateAllModels(List<AudioPlayerModel> updatedList) {
    audioPlayerModels.clear();
    audioPlayerModels.addAll(updatedList);
    return Future.value(audioPlayerModels);
  }
}