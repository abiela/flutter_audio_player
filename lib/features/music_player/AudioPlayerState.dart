import 'package:equatable/equatable.dart';

import '../../data/model/AudioPlayerModel.dart';

abstract class AudioPlayerState extends Equatable {
  const AudioPlayerState();
}

class AudioPlayerInitial extends AudioPlayerState {
  const AudioPlayerInitial();

  @override
  List<Object> get props => [];
}

class AudioPlayerReady extends AudioPlayerState {

  final List<AudioPlayerModel> entityList;

  const AudioPlayerReady(this.entityList);

  @override
  List<Object> get props => [entityList];
}

class AudioPlayerPlaying extends AudioPlayerState {

  final List<AudioPlayerModel> entityList;
  final AudioPlayerModel playingEntity;

  const AudioPlayerPlaying(this.playingEntity, this.entityList);

  @override
  List<Object> get props => [playingEntity, entityList];
}

class AudioPlayerPaused extends AudioPlayerState {

  final List<AudioPlayerModel> entityList;
  final AudioPlayerModel pausedEntity;

  const AudioPlayerPaused(this.pausedEntity, this.entityList);

  @override
  List<Object> get props => [pausedEntity];
}

class AudioPlayerFailure extends AudioPlayerState {
  
  final String error;
  
  const AudioPlayerFailure(this.error);

  @override
  List<Object> get props => [error];
}