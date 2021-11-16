import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/database/favorites.dart';
import 'package:musicsample/database/playlistmodel.dart';
import 'package:musicsample/pages/favoritePage.dart';
import 'package:musicsample/pages/playlistpage.dart';
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
  List<dynamic>? k;
  List<Audio>? audio = [];
  List<dynamic>? a = [];
  dynamic playlistbox = Hive.box('playlist');
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
    var playlistbox = Hive.box('playlist');

    final TextEditingController namecontroller = TextEditingController();
    String? title;
    // var a = playlistbox.get("title");
    return widget.audios == null
        ? CircularProgressIndicator()
        : Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
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
                                // openPlayer: widget.openPlayer,
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
                                                      showModalBottomSheet<
                                                          void>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            color: Colors.black,
                                                            child: Center(
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  ListView(
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    children: [
                                                                      ListTile(
                                                                        title:
                                                                            GestureDetector(
                                                                          child:
                                                                              Text(
                                                                            '+ Add Playlist',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          onTap: () =>
                                                                              showDialog<String>(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
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
                                                                                      if (namecontroller != null) {
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
                                                                      playlistbox ==
                                                                              null
                                                                          ? Text(
                                                                              'No Data here now',
                                                                              style: TextStyle(color: Colors.white),
                                                                            )
                                                                          : SingleChildScrollView(
                                                                              scrollDirection: Axis.vertical,
                                                                              child: ValueListenableBuilder(
                                                                                valueListenable: Hive.box('playlist').listenable(),
                                                                                builder: (context, Box playlist, _) {
                                                                                  Box databox = Hive.box('songbox');
                                                                                  var allsongsfromhive = databox.get('allsongs');

                                                                                  List<dynamic> keys = playlist.keys.toList();

                                                                                  return (ListView.separated(
                                                                                    physics: ScrollPhysics(),
                                                                                    scrollDirection: Axis.vertical,
                                                                                    itemCount: keys.length,
                                                                                    shrinkWrap: true,
                                                                                    itemBuilder: (context, ind) {
                                                                                      List<dynamic> findsong = allsongsfromhive
                                                                                          .where(
                                                                                            (element) => element['id'].toString().contains(
                                                                                                  widget.audios[index].metas.id.toString(),
                                                                                                ),
                                                                                          )
                                                                                          .toList();
                                                                                      List<dynamic> playlists = playlistbox.get(keys[ind]);
                                                                                      return GestureDetector(
                                                                                        onTap: () {},
                                                                                        child: ListTile(
                                                                                          leading: Icon(
                                                                                            Icons.playlist_play,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          title: Text(
                                                                                            playlist.keyAt(ind),
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          ),
                                                                                          trailing: TextButton(
                                                                                            onPressed: () {
                                                                                              setState(() {});
                                                                                            },
                                                                                            child: playlists.where((element) => element['id'].toString() == widget.audios[index].metas.id.toString()).isEmpty
                                                                                                ? GestureDetector(
                                                                                                    onTap: () {
                                                                                                      // List<dynamic> playlists = playlistbox.get(keys[ind]);
                                                                                                      playlists.add(findsong.first);
                                                                                                      playlistbox.put(keys[ind], playlists);

                                                                                                      setState(() {});
                                                                                                      Navigator.pop(context);
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                                        SnackBar(
                                                                                                          content: const Text('Song Added In Playlist'),
                                                                                                          duration: const Duration(seconds: 1),
                                                                                                        ),
                                                                                                      );
                                                                                                    },
                                                                                                    child: Text('Add to Playlist', style: TextStyle(color: Colors.white)))
                                                                                                : GestureDetector(
                                                                                                    onTap: () {
                                                                                                      print(findsong.first);
                                                                                                      playlists.remove(findsong.first);

                                                                                                      Navigator.pop(context);
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                                        SnackBar(
                                                                                                          content: const Text('Song Removed From Playlist'),
                                                                                                          duration: const Duration(seconds: 1),
                                                                                                        ),
                                                                                                      );
                                                                                                    },
                                                                                                    child: Text(
                                                                                                      'Remove From Playlist',
                                                                                                      style: TextStyle(color: Colors.white),
                                                                                                    ),
                                                                                                  ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                    separatorBuilder: (_, index) => Divider(
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
                                                    child: new Text(
                                                        'Add to Playlist')),
                                                value: 'Add playlist',
                                                onTap: () {},
                                              ),
                                              new PopupMenuItem<String>(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // var playlistind =
                                                    //     Hive.box('fovorites');

                                                    // playlistind.add(
                                                    //   Favoritesmodel(
                                                    //       index: index),
                                                    // );

                                                    // // : playlistind;
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         Favorites(
                                                    //       curindex: index,
                                                    //       audios: widget.audios,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  },
                                                  child: new Text(
                                                      'Add to Favorites'),
                                                ),
                                                value: 'Favorites',
                                                onTap: () {},
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
                },
              )
            ],
          );
  }
}
