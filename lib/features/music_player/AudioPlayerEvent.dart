import 'package:equatable/equatable.dart';
import 'package:flutteraudioplayer/data/model/AudioPlayerModel.dart';

abstract class AudioPlayerEvent extends Equatable {

  const AudioPlayerEvent();
}

class InitializeAudio extends AudioPlayerEvent {

  const InitializeAudio();

  @override
  List<Object> get props => [];
}

class TriggeredPlayAudio extends AudioPlayerEvent {

  final AudioPlayerModel audioPlayerModel;

  const TriggeredPlayAudio(this.audioPlayerModel);

  @override
  List<Object> get props => [audioPlayerModel];
}

class TriggeredPauseAudio extends AudioPlayerEvent {

  final AudioPlayerModel audioPlayerModel;

  const TriggeredPauseAudio(this.audioPlayerModel);

  @override
  List<Object> get props => [audioPlayerModel];
}

class AudioPlayed extends AudioPlayerEvent {

  final String audioModelMetaId;

  const AudioPlayed(this.audioModelMetaId);

  @override
  List<Object> get props => [audioModelMetaId];
}

class AudioPaused extends AudioPlayerEvent {

  final String audioModelMetaId;

  const AudioPaused(this.audioModelMetaId);

  @override
  List<Object> get props => [audioModelMetaId];
}

class AudioStopped extends AudioPlayerEvent {

  const AudioStopped();

  @override
  List<Object> get props => [];
}