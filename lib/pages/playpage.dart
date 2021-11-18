import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
            IconButton(
              onPressed: () {
                final TextEditingController namecontroller =
                    TextEditingController();
                String? title;
                var playlistbox = Hive.box('playlist');
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                ListTile(
                                  title: GestureDetector(
                                    child: Text(
                                      '+ Add Playlist',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        List<dynamic> dummylist = [];
                                        return AlertDialog(
                                          backgroundColor: Colors.black,
                                          title: Text(
                                            'Create New Playlist',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          actions: [
                                            TextField(
                                              controller: namecontroller,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(),
                                                hintText: 'Playlist Name',
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if (namecontroller
                                                    .text.isNotEmpty) {
                                                  title = namecontroller.text;
                                                  title!.isNotEmpty
                                                      ? playlistbox.put(
                                                          title,
                                                          dummylist,
                                                        )
                                                      : playlistbox;
                                                  setState(() {});
                                                  Navigator.pop(context, 'OK');
                                                  namecontroller.clear();
                                                }
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap:
                                //       () {
                                //     playlistbox.clear();
                                //     // Navigator.push(
                                //     //   context,
                                //     //   MaterialPageRoute(
                                //     //     builder: (context) => Favorites(
                                //     //       audios: widget.audios,
                                //     //       title: 'Favorites',
                                //     //     ),
                                //     //   ),
                                //     // );
                                //     List<dynamic>
                                //         dummylist =
                                //         [];
                                //   },
                                //   child:
                                //       ListTile(
                                //     tileColor:
                                //         Colors.white30,
                                //     title:
                                //         Text(
                                //       'Favorites',
                                //       style: TextStyle(color: Colors.white),
                                //     ),
                                //     trailing:
                                //         Icon(Icons.favorite, color: Colors.white),
                                //   ),
                                // ),
                                playlistbox == null
                                    ? Text(
                                        'No Data here now',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: ValueListenableBuilder(
                                          valueListenable:
                                              Hive.box('playlist').listenable(),
                                          builder: (context, Box playlist, _) {
                                            Box databox = Hive.box('songbox');
                                            var allsongsfromhive =
                                                databox.get('allsongs');

                                            List<dynamic> keys =
                                                playlist.keys.toList();

                                            return (ListView.separated(
                                              physics: ScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount: keys.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, ind) {
                                                List<dynamic> findsong =
                                                    allsongsfromhive
                                                        .where(
                                                          (element) =>
                                                              element['id']
                                                                  .toString()
                                                                  .contains(
                                                                    widget
                                                                        .audio[widget
                                                                            .index]
                                                                        .metas
                                                                        .id
                                                                        .toString(),
                                                                  ),
                                                        )
                                                        .toList();
                                                List<dynamic> playlists =
                                                    playlistbox.get(keys[ind]);
                                                return GestureDetector(
                                                  onTap: () {},
                                                  child: ListTile(
                                                    leading: Icon(
                                                      Icons.playlist_play,
                                                      color: Colors.white,
                                                    ),
                                                    title: Text(
                                                      playlist.keyAt(ind),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    trailing: TextButton(
                                                      onPressed: () {
                                                        setState(() {});
                                                      },
                                                      child: playlists
                                                              .where((element) =>
                                                                  element['id']
                                                                      .toString() ==
                                                                  widget
                                                                      .audio[widget
                                                                          .index]
                                                                      .metas
                                                                      .id
                                                                      .toString())
                                                              .isEmpty
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                // List<dynamic> playlists = playlistbox.get(keys[ind]);
                                                                playlists.add(
                                                                    findsong
                                                                        .first);
                                                                playlistbox.put(
                                                                    keys[ind],
                                                                    playlists);

                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        const Text(
                                                                            'Song Added In Playlist'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                'Add to Playlist',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                print(findsong
                                                                    .first);
                                                                playlists.removeWhere((element) =>
                                                                    element['id']
                                                                        .toString() ==
                                                                    findsong
                                                                        .first[
                                                                            'id']
                                                                        .toString());
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        const Text(
                                                                            'Song Removed From Playlist'),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                'Remove From Playlist',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder: (_, index) =>
                                                  Divider(
                                                color: Colors.white,
                                              ),
                                            ));
                                          },
                                        ),
                                      )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.library_add,
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
                                  trailing: GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                      userTouch = false;
                                    },
                                    onDoubleTap: () {
                                      setState(() {});
                                      userTouch = true;
                                    },
                                    child: Icon(
                                      userTouch
                                          ? Icons.favorite_border
                                          : Icons.favorite,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       myAudio!.metas.title!,
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //       style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 28,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //     GestureDetector(
                                //       onTap: () {
                                //         setState(() {});
                                //         userTouch = false;
                                //       },
                                //       onDoubleTap: () {
                                //         setState(() {});
                                //         userTouch = true;
                                //       },
                                //       child: Icon(
                                //         userTouch
                                //             ? Icons.favorite_border
                                //             : Icons.favorite,
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       myAudio!.metas.artist!,
                                //       // maxLines: 1,
                                //       // overflow: TextOverflow.ellipsis,
                                //       style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 13,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //   ],
                                // ),
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
                                            // loopMode: loopMode,
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
