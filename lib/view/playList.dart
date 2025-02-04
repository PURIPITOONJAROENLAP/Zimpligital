import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octo_image/octo_image.dart';

import '../bloc/models/musicModel.dart';

class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  MusicModel? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;


  final List<MusicModel> songs = [
    MusicModel(title:"Tech House Vibes",artist :'A&K' ,src : 'music/listen-chill.mp3',imageCover:'assets/image/1.png',album:'',time: const Duration(seconds: 164)),
    MusicModel(title:"Summer Hits",artist :'Hits' ,src : 'music/summer-hits.mp3',imageCover:'assets/image/2.png',album:'',time: const Duration(seconds: 141)),
    MusicModel(title:"Listen & Chill",artist :'Hipster' ,src : 'music/tech-house.mp3',imageCover:'assets/image/3.png',album:'',time: const Duration(seconds: 153)),
  ];

  void _togglePlay(MusicModel song) async {
    if (_currentSong?.src == song.src) {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.resume();
        setState(() => _isPlaying = true);
      }
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(song.src!));

      setState(() {
        _currentSong = song;
        _isPlaying = true;
        _position = Duration.zero;
      });

      _audioPlayer.onPositionChanged.listen((Duration position) {
        setState(() {
          _position = position;
        });
      });
    }
  }


  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _audioPlayer.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Playlist",style: TextStyle(fontSize:25,fontWeight: FontWeight.w700),),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        physics: const ClampingScrollPhysics(),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                OctoImage(
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  image: AssetImage("${song.imageCover}"),
                  placeholderBuilder: (_) => const Center(
                    child: SpinKitThreeBounce(
                      color: Colors.blue,
                      size: 23,
                    ),
                  ),
                  errorBuilder: (context, error, stacktrace) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color:Colors.grey,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _togglePlay(song),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(song.title!,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                          Text(song.artist!),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying && _currentSong?.src == song.src
                        ? Icons.pause_circle_outline_outlined
                        : Icons.play_circle_outline,
                    size: 35,
                    color: Colors.grey,
                  ),
                  onPressed: () => _togglePlay(song),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _currentSong != null
        ? SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: _currentSong!.time!.inMilliseconds > 0
                  ? _position.inMilliseconds /  _currentSong!.time!.inMilliseconds
                  : 0,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    OctoImage(
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      image: AssetImage("${_currentSong?.imageCover}"),
                      placeholderBuilder: (_) => const Center(
                        child: SpinKitThreeBounce(
                          color: Colors.blue,
                          size: 23,
                        ),
                      ),
                      errorBuilder: (context, error, stacktrace) {
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color:Colors.grey,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _togglePlay(_currentSong!),
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(_currentSong!.title!,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                              Text(_currentSong!.artist!),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying
                          ? Icons.pause_outlined
                          : Icons.play_arrow_rounded,
                        size: 35,
                        color: Colors.black,
                      ),
                      onPressed: () => _togglePlay(_currentSong!),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
        : const SizedBox(),
    );
  }
}
