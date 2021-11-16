import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/database/playlistmodel.dart';
import 'package:musicsample/pages/playpage.dart';
import 'package:on_audio_query/on_audio_query.dart';

class playlistpage extends StatefulWidget {
  List<dynamic> audios;
  String title;
  playlistpage({Key? key, required this.title, required this.audios})
      : super(key: key);

  @override
  _playlistpageState createState() => _playlistpageState();
}

class _playlistpageState extends State<playlistpage> {
  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  void openPlayer(
    int index,
  ) async {
    await assetsAudioPlayer.open(Playlist(audios: audio, startIndex: index),
        showNotification: true,
        autoStart: true,
        notificationSettings: NotificationSettings(stopEnabled: false));
  }

  List<Audio> audio = [];
  List<dynamic> a = [];
  dynamic playlistbox = Hive.box('playlist');
  bool isUserPressed = false;
  @override
  Widget build(BuildContext context) {
    a = playlistbox.get(widget.title);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.title,
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Box databox = Hive.box('songbox');
                  List<dynamic> allsongsfromhive = databox.get('allsongs');
                  print(allsongsfromhive[0]['id']);
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        // height: MediaQuery.of(context).size.height / 1.5,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                  child: bottam(
                                      audios: widget.audios,
                                      title: widget.title))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  '+ Add Song Into This PlayList',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              playlistList()
            ],
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<Box<dynamic>> playlistList() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('playlist').listenable(),
      builder: (context, Box todos, _) {
        audio = [];
        List<dynamic> keys = todos.get(widget.title);
        for (var i = 0; i <= keys.length - 1; i++) {
          Audio? newaudio = Audio.file(
            keys[i]['uri'].toString(),
            metas: Metas(
              id: keys[i]['id'].toString(),
              title: keys[i]['title'],
              album: keys[i]['album'],
              artist: keys[i]['artist'],
              image: MetasImage.file(
                keys[i]['uri'].toString(),
              ),
            ),
          );

          audio.add(newaudio);
        }
        return (ListView.separated(
          physics: ScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: keys.length,
          shrinkWrap: true,
          itemBuilder: (context, ind) {
            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PlaylistPage(
                //       title: todos.keyAt(ind),
                //       curindex: widget.audios[ind],
                //     ),
                //   ),
                // );
              },
              child: GestureDetector(
                onTap: () {
                  openPlayer(ind);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayPage(audio: audio, index: ind),
                    ),
                  );
                },
                child: ListTile(
                  // onTap: () {
                  //   print(audio.length.toString() +
                  //       "-----------------------------");
                  // },
                  title: Text(
                    keys[ind]['title'],
                    // audio[ind].metas.title.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      keys.removeAt(ind);
                      setState(() {});
                      // todos.deleteAt(keys[ind]);
                    },
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
    );
  }
}

class bottam extends StatefulWidget {
  List<dynamic> audios;
  String title;
  bottam({Key? key, required this.audios, required this.title})
      : super(key: key);

  @override
  _bottamState createState() => _bottamState();
}

class _bottamState extends State<bottam> {
  List<Audio> audio = [];
  dynamic playlistbox = Hive.box('playlist');
  List<dynamic> a = [];
  @override
  Widget build(BuildContext context) {
    Box databox = Hive.box('songbox');
    List<dynamic> allsongsfromhive = databox.get('allsongs');
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.audios.length,
      itemBuilder: (context, index) {
        final k = allsongsfromhive.firstWhere((element) => element['id']
            .toString()
            .contains(widget.audios[index].metas.id.toString()));
        int image = int.parse(widget.audios[index].metas.id.toString());
        return ListTile(
          leading: QueryArtworkWidget(
            nullArtworkWidget: FlutterLogo(),
            id: image,
            type: ArtworkType.AUDIO,
          ),
          title: Text(
            widget.audios[index].metas.title.toString(),
            style: TextStyle(color: Colors.black),
          ),
          trailing: a
                  .where((element) =>
                      element['id'].toString() ==
                      widget.audios[index].metas.id.toString())
                  .isEmpty
              ? GestureDetector(
                  onTap: () {
                    // k = allsongsfromhive
                    //     .where((element) =>
                    //         element['id']
                    //             .toString()
                    //             .contains(widget
                    //                 .audios[index]
                    //                 .metas
                    //                 .id
                    //                 .toString()))
                    //     .toList();
                    print(a);
                    a.add(k);

                    playlistbox.put(widget.title, a);
                    setState(
                      () {},
                    );
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      a = playlistbox.get(widget.title);
                      print(a);
                      a.removeWhere((element) =>
                          element['id'].toString() == k['id'].toString());
                      playlistbox.put(widget.title, a);
                    });
                  },
                  child: Icon(
                    Icons.check_box,
                    color: Colors.black,
                  ),
                ),
        );
      },
    );
  }
}
