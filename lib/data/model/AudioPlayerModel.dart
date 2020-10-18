import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:equatable/equatable.dart';

class AudioPlayerModel extends Equatable {

  final String id;
  final Audio audio;
  final bool isPlaying;

  const AudioPlayerModel({this.id, this.audio, this.isPlaying});

  @override
  List<Object> get props => [this.id, this.isPlaying];

  @override
  bool get stringify => true;

  AudioPlayerModel copyWithIsPlaying(bool isPlaying) {
    return AudioPlayerModel(id: this.id, audio: this.audio, isPlaying: isPlaying);
  }
}