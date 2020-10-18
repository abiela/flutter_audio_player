import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteraudioplayer/pages/MusicPage.dart';

import 'data/repository/AudioPlayerModelFactory.dart';
import 'data/repository/AudioPlayerRepository.dart';
import 'data/repository/InMemoryAudioPlayerRepository.dart';
import 'features/music_player/AudioPlayerBloc.dart';

void main() {
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    print(notification.audioId);
    return true;
  });

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AudioPlayerRepository>(
          create: (context) => InMemoryAudioPlayerRepository(
              audioPlayerModels: AudioPlayerModelFactory.getAudioPlayerModels()
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AudioPlayerBloc>(
            create: (BuildContext context) => AudioPlayerBloc(
                assetsAudioPlayer: AssetsAudioPlayer.newPlayer(),
                audioPlayerRepository:
                    RepositoryProvider.of<AudioPlayerRepository>(context)),
          ),
        ],
        child: MaterialApp(
            title: "Audio player",
            debugShowCheckedModeBanner: false,
            home: MainScreen()),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Audio player"),
        ),
        body: MusicPage()
    );
  }
}
