import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerBloc.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerEvent.dart';
import 'package:flutteraudioplayer/features/music_player/AudioPlayerState.dart';
import 'package:flutteraudioplayer/ui/widget/AudioTrackWidget.dart';
import 'package:flutteraudioplayer/ui/widget/PlayerWidget.dart';

class MusicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
            builder: (context, state) {
              if (state is AudioPlayerInitial) {
                BlocProvider.of<AudioPlayerBloc>(context).add(
                    InitializeAudio());
                return buildCircularProgress();
              }

              else if (state is AudioPlayerReady) {
                return buildReadyTrackList(state);
              }

              else if (state is AudioPlayerPlaying) {
                return buildPlayingTrackList(state);
              }

              else if (state is AudioPlayerPaused) {
                return buildPausedTrackList(state);
              }

              else {
                return buildUnknownStateError();
              }
            }));
  }

  Widget buildReadyTrackList(AudioPlayerReady state) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return AudioTrackWidget(audioPlayerModel: state.entityList[index]);
        },
        itemCount: state.entityList.length);
  }

  Widget buildPlayingTrackList(AudioPlayerPlaying state) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 124),
              itemBuilder: (BuildContext context, int index) {
                return AudioTrackWidget(
                    audioPlayerModel: state.entityList[index]);
              },
              itemCount: state.entityList.length),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: PlayerWidget(),
        )
      ],
    );
  }

  Widget buildPausedTrackList(AudioPlayerPaused state) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 96),
              itemBuilder: (BuildContext context, int index) {
                return AudioTrackWidget(
                    audioPlayerModel: state.entityList[index]);
              },
              itemCount: state.entityList.length),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: PlayerWidget(),
        )
      ],
    );
  }

  Widget buildCircularProgress() {
    return Center(child: CircularProgressIndicator());
  }

  Widget buildUnknownStateError() {
    return Text("Unknown state error");
  }
}
