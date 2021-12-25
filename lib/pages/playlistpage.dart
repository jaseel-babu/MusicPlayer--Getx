import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/controller/controller.dart';
import 'package:musicsample/functionalities/openPlayer.dart';
import 'package:musicsample/pages/playpage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class playlistpage extends StatelessWidget {
  final List<dynamic> audios;
  final String title;
  playlistpage({Key? key, required this.title, required this.audios})
      : super(key: key);

  final controller = Get.put(Controller());

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  String? theme;
  String? backimgpath;
  gettheme() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    theme = await sharedPref.getString('theme');
    controller.update();
  }

  List<Audio> audio = [];
  List<dynamic> a = [];
  dynamic playlistbox = Hive.box('playlist');
  bool isUserPressed = false;
  @override
  Widget build(BuildContext context) {
    if (theme == null ||
        theme == 'Background Image 1' ||
        theme == 'Change Background Image') {
      backimgpath = 'assets/images/fYV9z3.webp';
    } else if (theme == 'Background Image 2') {
      backimgpath = 'assets/images/darkper.jpg';
    } else if (theme == 'Background Image 3') {
      backimgpath = 'assets/images/_.jpeg';
    }
    a = playlistbox.get(title);
    return SafeArea(
      child: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage(backimgpath!),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline1,
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
                    
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (context) {
                          return bottam(name: title);
                        },
                      );
                    },
                    child: Text(
                      '+ Add Song Into This PlayList',
                      style: TextStyle(color: Colors.white),
                    )),
                playlistList()
              ],
            ),
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
        List<dynamic> keys = todos.get(title);
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
        return GetBuilder<Controller>(
          id: "deleted",
          builder: (contreller) {
            return (ListView.separated(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: keys.length,
              shrinkWrap: true,
              itemBuilder: (context, ind) {
                return ListTile(
                  title: Text(keys[ind]['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1),
                  leading: QueryArtworkWidget(
                    nullArtworkWidget:
                        Image.asset('assets/images/Neon Apple Music Logo.png'),
                    id: keys[ind]['id'],
                    type: ArtworkType.AUDIO,
                  ),
                  subtitle: Text(keys[ind]['artist'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2),
                  onTap: () {
                    assetsAudioPlayer.stop();
                    OpenPlayer().openPlayer(ind, audio);
                    Get.to(() => PlayPage(audio: audio, index: ind));
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      keys.removeAt(ind);
                      controller.update(["deleted"]);
                    },
                  ),
                );
              },
              separatorBuilder: (_, index) => Divider(
                color: Colors.white,
              ),
            ));
          },
        );
      },
    );
  }
}

class bottam extends StatelessWidget {
  bottam({Key? key, required this.name}) : super(key: key);
  final name;
  final controller = Get.put(Controller());
  Box playlistbox = Hive.box('playlist');
  List<dynamic> a = [];
  @override
  Widget build(BuildContext context) {
    Box databox = Hive.box('songbox');
    List<dynamic> allsongsfromhive = databox.get('allsongs');
    List<dynamic> playlist = playlistbox.get(name);
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: allsongsfromhive.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: QueryArtworkWidget(
            nullArtworkWidget:
                Image.asset('assets/images/Neon Apple Music Logo.png'),
            id: allsongsfromhive[index]['id'],
            type: ArtworkType.AUDIO,
          ),
          title: Text(
            allsongsfromhive[index]['title'],
            style: TextStyle(color: Colors.black),
          ),
          trailing: GetBuilder<Controller>(
            id: "playlist",
            builder: (controller) {
              return playlist
                      .where((element) =>
                          element["id"].toString() ==
                          allsongsfromhive[index]["id"].toString())
                      .isEmpty
                  ? GestureDetector(
                      onTap: () {
                        playlist.add(allsongsfromhive[index]);
                        playlistbox.put(name, playlist);
                        controller.update(["playlist"]);
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        playlist.removeWhere((element) =>
                            element['id'].toString() ==
                            allsongsfromhive[index]['id'].toString());
                        playlistbox.put(name, playlist);
                        controller.update(["playlist"]);
                      },
                      child: Icon(
                        Icons.check_box,
                        color: Colors.black,
                      ),
                    );
            },
          ),
        );
      },
    );
  }
}
