import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/duration.dart';
import 'package:musicsample/functionalities/addsongplaylist.dart';
import 'package:musicsample/functionalities/favoriteButton.dart';
import 'package:musicsample/functionalities/favoriteButton.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../controll.dart';

class PlayPage extends StatefulWidget {
  int index;
  List<Audio> audio;

  PlayPage({required this.audio, required this.index});

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  bool userTouch = true;

  bool isPlaying = false;

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');

  @override
  void initState() {
    super.initState();
    // setSong();
  }

  Audio? myAudio;

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: new AssetImage(
              'assets/images/7d8fe1bd2a0073864b4c10b4f483d48a.jpg'),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 100,
            title: Text(
              "Now Playing",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ),
            actions: [
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: assetsAudioPlayer.builderCurrent(
            builder: (context, Playing? playing) {
              myAudio = find(widget.audio, playing!.audio.assetAudioPath);
              var image = int.parse(myAudio!.metas.id!);
              var over = widget.audio.length;

              return myAudio == null
                  ? Center(
                      child: Text(
                        'Please Select Song',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 48.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 300,
                                  height: 300,
                                  child: QueryArtworkWidget(
                                    nullArtworkWidget: Image.asset(
                                        'assets/images/Neon Apple Music Logo.png'),
                                    id: image,
                                    type: ArtworkType.AUDIO,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                ListTile(
                                    title: Text(
                                      myAudio!.metas.title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      myAudio!.metas.artist!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FavoriteButton(
                                          myAudio: myAudio!,
                                        ),
                                        AddSongToPlaylist(
                                          audio: myAudio!,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: <Widget>[
                              assetsAudioPlayer.builderRealtimePlayingInfos(
                                builder: (context,
                                    RealtimePlayingInfos? currentinfo) {
                                  if (currentinfo == null) {
                                    return Text(
                                      'Sorry',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0,
                                            right: 25.0,
                                            top: 20.0,
                                            bottom: 20.0),
                                        child: ProgressBar(
                                          thumbRadius: 0.0,
                                          thumbColor: Colors.white,
                                          progressBarColor: Colors.pink[900],
                                          progress: currentinfo.currentPosition,
                                          total: currentinfo.duration,
                                          onSeek: (to) {
                                            assetsAudioPlayer.seek(to);
                                          },
                                        ),
                                      ),
                                      PositionSeekWidget(
                                          currentPosition:
                                              currentinfo.currentPosition,
                                          duration: currentinfo.duration),
                                      PlayerBuilder.isPlaying(
                                        player: assetsAudioPlayer,
                                        builder: (context, isPlaying) {
                                          bool nextDone = true;
                                          bool prevDone = true;
                                          return PlayingControls(
                                            isPlaying: isPlaying,
                                            isPlaylist: true,
                                            onPlay: () async {
                                              await assetsAudioPlayer
                                                  .playOrPause();
                                            },
                                            onNext: () async {
                                              if (nextDone) {
                                                nextDone = false;
                                                await assetsAudioPlayer.next();
                                                nextDone = true;
                                              }
                                            },
                                            onPrevious: () async {
                                              if (prevDone) {
                                                prevDone = false;
                                                await assetsAudioPlayer
                                                    .previous();
                                                prevDone = true;
                                              }
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
