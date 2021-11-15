import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/database/favorites.dart';
import 'package:musicsample/database/playlistmodel.dart';
import 'package:musicsample/pages/addsongtoplaylist.dart';
import 'package:musicsample/pages/favoritePage.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'playpage.dart';

class Songlist extends StatefulWidget {
  List<Audio> audios;
  Function openPlayer;
  Songlist({Key? key, required this.audios, required this.openPlayer})
      : super(key: key);

  @override
  _SonglistState createState() => _SonglistState();
}

class _SonglistState extends State<Songlist> {
  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');

  @override
  void initState() {
    super.initState();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  Audio? myAudio;
  var ind = 0;
  @override
  Widget build(BuildContext context) {
    return widget.audios == null
        ? CircularProgressIndicator()
        : Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  // height: 550,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: widget.audios.length,
                    itemBuilder: (context, index) {
                      ind = index;
                      var image =
                          int.parse(widget.audios[index].metas.id.toString());
                      return GestureDetector(
                        onTap: () {
                          widget.openPlayer(index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayPage(
                                openPlayer: widget.openPlayer,
                                audio: widget.audios,
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 120,
                                    child: QueryArtworkWidget(
                                      nullArtworkWidget: FlutterLogo(),
                                      id: image,
                                      type: ArtworkType.AUDIO,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            widget.audios[index].metas.title!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton(
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                          ),
                                          itemBuilder: (context) {
                                            return <PopupMenuItem<String>>[
                                              new PopupMenuItem<String>(
                                                child: GestureDetector(
                                                    onTap: () {
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         AddLibrary(
                                                      //       currentindex: widget
                                                      //           .audios[index],
                                                      //       audio:
                                                      //           widget.audios,
                                                      //     ),
                                                      //   ),
                                                      // );
                                                    },
                                                    child: new Text(
                                                        'Add to Playlist')),
                                                value: 'Add playlist',
                                                onTap: () {},
                                              ),
                                              new PopupMenuItem<String>(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    var playlistind =
                                                        Hive.box('fovorites');
                                                    // Favoritesmodel? a =
                                                    //     playlistind.get(index);
                                                    // var a = playlistind.values
                                                    //     .toList();
                                                    // .toList();
                                                    // print(a!.index);
                                                    // var b = a.contains(index);
                                                    // b == true
                                                    //     ?;

                                                    playlistind.add(
                                                      Favoritesmodel(
                                                          index: index),
                                                    );

                                                    // : playlistind;
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Favorites(
                                                          curindex: index,
                                                          audios: widget.audios,
                                                        ),
                                                      ),
                                                    );

                                                    // Tooltip(
                                                    //   message: 'Item Added',
                                                    //   textStyle: TextStyle(
                                                    //       color: Colors.white),
                                                    //   decoration: BoxDecoration(
                                                    //       color: Colors.red),
                                                    // );
                                                  },
                                                  child: new Text(
                                                      'Add to Favorites'),
                                                ),
                                                value: 'Favorites',
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         AddLibrary(),
                                                  //   ),
                                                  // );
                                                },
                                              ),
                                            ];
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              assetsAudioPlayer.builderCurrent(
                builder: (context, Playing? playing) {
                  myAudio = find(widget.audios, playing!.audio.assetAudioPath);
                  return Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Recently Played',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 18,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayPage(
                                    openPlayer: widget.openPlayer,
                                    audio: widget.audios,
                                    index: 0,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.pink[900],
                              ),
                              child: ListTile(
                                title: Text(
                                  myAudio!.metas.title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  myAudio!.metas.artist!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  // );
                },
              )
            ],
          );
  }
}
