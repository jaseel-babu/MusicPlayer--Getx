import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicsample/duration.dart';
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
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
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.library_add,
            //     color: Colors.white,
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                setState(() {});
                userTouch = false;
              },
              onDoubleTap: () {
                setState(() {});
                userTouch = true;
              },
              child: Icon(
                userTouch ? Icons.favorite_border : Icons.favorite,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: assetsAudioPlayer.builderCurrent(
          builder: (context, Playing? playing) {
            myAudio = find(widget.audio, playing!.audio.assetAudioPath);
            var image = int.parse(myAudio!.metas.id!);
            return myAudio == null
                ? Center(
                    child: Text(
                      'Please Select Song',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 48.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  width: 250,
                                  height: 200,
                                  child: QueryArtworkWidget(
                                    nullArtworkWidget: Image.asset(
                                        'assets/images/defaultImage.jpg'),
                                    id: image,
                                    type: ArtworkType.AUDIO,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: Text(
                                    myAudio!.metas.title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    widget.audio[widget.index].metas.artist!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
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
                                        padding: const EdgeInsets.all(25.0),
                                        child: ProgressBar(
                                          thumbRadius: 8.0,
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
                                            // loopMode: loopMode,
                                            isPlaying: isPlaying,
                                            isPlaylist: true,
                                            onPlay: () {
                                              assetsAudioPlayer.playOrPause();
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
                                            // onRepeat: () {
                                            //   assetsAudioPlayer.loopMode;
                                            // },
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
                    ),
                  );
          },
        ),
      ),
    );
  }
}
