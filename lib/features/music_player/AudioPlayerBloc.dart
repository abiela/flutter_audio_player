import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteraudioplayer/data/model/AudioPlayerModel.dart';
import 'package:flutteraudioplayer/data/repository/AudioPlayerRepository.dart';
import 'dart:async';

import 'AudioPlayerEvent.dart';
import 'AudioPlayerState.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {

  final AssetsAudioPlayer assetsAudioPlayer;
  final AudioPlayerRepository audioPlayerRepository;

  List<StreamSubscription> playerSubscriptions = new List();

  AudioPlayerBloc({this.assetsAudioPlayer, this.audioPlayerRepository}) {
    playerSubscriptions.add(
        assetsAudioPlayer.playerState.listen((event) {
          _mapPlayerStateToEvent(event);
        }));
  }

  @override
  AudioPlayerState get initialState => AudioPlayerInitial();

  @override
  Stream<AudioPlayerState> mapEventToState(AudioPlayerEvent event) async* {
    if (event is InitializeAudio) {
      final audioList = await audioPlayerRepository.getAll();
      yield AudioPlayerReady(audioList);
    }

    if (event is AudioPlayed) {
      yield* _mapAudioPlayedToState(event);
    }
    if (event is AudioPaused) {
      yield* _mapAudioPausedToState(event);
    }

    if (event is AudioStopped) {
      yield* _mapAudioStoppedToState();
    }

    if (event is TriggeredPlayAudio) {
      yield* _mapTriggeredPlayAudio(event);
    }

    if (event is TriggeredPauseAudio) {
      yield* _mapTriggeredPausedAudio(event);
    }

    }

  @override
  Future<Function> close() {
    playerSubscriptions.forEach((element) {
      element.cancel();
    });
    return assetsAudioPlayer.dispose();
  }

  void _mapPlayerStateToEvent(PlayerState playerState) {
    if (playerState == PlayerState.stop) {
      add(AudioStopped());
    }

    else if (playerState == PlayerState.pause) {
      add(AudioPaused(assetsAudioPlayer.current.value.audio.audio.metas.id));
    }

    else if (playerState == PlayerState.play) {
      add(AudioPlayed(assetsAudioPlayer.current.value.audio.audio.metas.id));
    }
  }

  Stream<AudioPlayerState> _mapAudioPlayedToState(AudioPlayed event) async* {
    final List<AudioPlayerModel> currentList = await audioPlayerRepository.getAll();
    final List<AudioPlayerModel> updatedList =
    currentList
        .map((audioModel) => audioModel.audio.metas.id == event.audioModelMetaId ? audioModel.copyWithIsPlaying(true) : audioModel.copyWithIsPlaying(false))
        .toList();
    await audioPlayerRepository.updateAllModels(updatedList);
    final AudioPlayerModel currentlyPlaying = updatedList.firstWhere((model) => model.audio.metas.id == event.audioModelMetaId);
    yield AudioPlayerPlaying(currentlyPlaying, updatedList);
  }

  Stream<AudioPlayerState> _mapAudioPausedToState(AudioPaused event) async* {
    final List<AudioPlayerModel> currentList = await audioPlayerRepository.getAll();
    final List<AudioPlayerModel> updatedList =
    currentList
        .map((audioModel) => audioModel.audio.metas.id == event.audioModelMetaId ? audioModel.copyWithIsPlaying(false) : audioModel)
        .toList();
    await audioPlayerRepository.updateAllModels(updatedList);
    final AudioPlayerModel currentlyPaused = currentList.firstWhere((model) => model.audio.metas.id == event.audioModelMetaId);
    yield AudioPlayerPaused(currentlyPaused, updatedList);
  }

  Stream<AudioPlayerState> _mapAudioStoppedToState() async* {
    final List<AudioPlayerModel> currentList = await audioPlayerRepository.getAll();
    final List<AudioPlayerModel> updatedList =
    currentList
        .map((audioModel) => audioModel.isPlaying ? audioModel.copyWithIsPlaying(false) : audioModel)
        .toList();
    yield AudioPlayerReady(updatedList);
    audioPlayerRepository.updateAllModels(updatedList);
  }

  Stream<AudioPlayerState> _mapTriggeredPlayAudio(TriggeredPlayAudio event) async* {
      if (state is AudioPlayerReady) {
        final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
        final updatedList = await audioPlayerRepository.updateModel(updatedModel);

        await assetsAudioPlayer.open(
            updatedModel.audio,
            showNotification: true
        );

        yield AudioPlayerPlaying(updatedModel, updatedList);
      }

      if (state is AudioPlayerPaused) {
        if (event.audioPlayerModel.id == (state as AudioPlayerPaused).pausedEntity.id) {
          final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
          final updatedList = await audioPlayerRepository.updateModel(updatedModel);

          await assetsAudioPlayer.play();

          yield AudioPlayerPlaying(updatedModel, updatedList);
        }
        else {
          final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
          final updatedList = await audioPlayerRepository.updateModel(updatedModel);

          await assetsAudioPlayer.open(
              updatedModel.audio,
              showNotification: true,
              respectSilentMode: true,
              headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug
          );

          yield AudioPlayerPlaying(updatedModel, updatedList);
        }
      }

      if (state is AudioPlayerPlaying) {
        final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
        final updatedList = await audioPlayerRepository.updateModel(updatedModel);

        await assetsAudioPlayer.open(
            updatedModel.audio,
            showNotification: true
        );

        yield AudioPlayerPlaying(updatedModel, updatedList);
      }
  }

  Stream<AudioPlayerState> _mapTriggeredPausedAudio(TriggeredPauseAudio event) async* {
    final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(false);
    final updatedList = await audioPlayerRepository.updateModel(updatedModel);

    await assetsAudioPlayer.pause();

    yield AudioPlayerPaused(updatedModel, updatedList);
  }
}