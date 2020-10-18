import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteraudioplayer/data/model/AudioPlayerModel.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerBloc.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerEvent.dart';

class AudioTrackWidget extends StatelessWidget {
  final AudioPlayerModel audioPlayerModel;

  const AudioTrackWidget({Key key, @required this.audioPlayerModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: setLeading(),
      title: setTitle(),
      subtitle: setSubtitle(),
      trailing: IconButton(
        icon: setIcon(),
        onPressed: setCallback(context),
      ),
    );
  }

  Widget setIcon() {
    if (audioPlayerModel.isPlaying)
      return Icon(Icons.pause);
    else
      return Icon(Icons.play_arrow);
  }

  Widget setLeading() {
    return new Image.asset(audioPlayerModel.audio.metas.image.path);
  }

  Widget setTitle() {
    return Text(audioPlayerModel.audio.metas.title);
  }

  Widget setSubtitle() {
    return Text(audioPlayerModel.audio.metas.artist);
  }

  Function setCallback(BuildContext context) {
    if (audioPlayerModel.isPlaying)
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPauseAudio(audioPlayerModel));
      };
    else
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPlayAudio(audioPlayerModel));
      };
  }
}
