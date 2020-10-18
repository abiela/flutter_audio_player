import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteraudioplayer/data/model/AudioPlayerModel.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerBloc.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerEvent.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerState.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        if (state is AudioPlayerInitial || state is AudioPlayerReady) {
          return SizedBox.shrink();
        }
        if (state is AudioPlayerPlaying) {
          return _showPlayer(context, state.playingEntity);
        }
        if (state is AudioPlayerPaused) {
          return _showPlayer(context, state.pausedEntity);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _showPlayer(BuildContext context, AudioPlayerModel model) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            color: Colors.grey.shade200,
            child: ListTile(
              leading: setLeading(model),
              title: setTitle(model),
              subtitle: setSubtitle(model),
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              trailing: IconButton(
                icon: setIcon(model),
                onPressed: setCallback(context, model),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setIcon(AudioPlayerModel model) {
    if (model.isPlaying)
      return Icon(Icons.pause);
    else
      return Icon(Icons.play_arrow);
  }

  Widget setLeading(AudioPlayerModel model) {
      return new Image.asset(model.audio.metas.image.path);
  }

  Widget setTitle(AudioPlayerModel model) {
    return Text(model.audio.metas.title);
  }

  Widget setSubtitle(AudioPlayerModel model) {
    return Text(model.audio.metas.artist);
  }

  Function setCallback(BuildContext context, AudioPlayerModel model) {
    if (model.isPlaying)
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPauseAudio(model));
      };
    else
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPlayAudio(model));
      };
  }
}
