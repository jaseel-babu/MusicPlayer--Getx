import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/controller/controller.dart';

class AddSongToPlaylist extends StatelessWidget {
  final Audio audio;
  AddSongToPlaylist({Key? key, required this.audio}) : super(key: key);
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final TextEditingController namecontroller = TextEditingController();
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
                              '+Create New Playlist',
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
                                        if (namecontroller.text.isNotEmpty) {
                                          title = namecontroller.text;
                                          title!.isNotEmpty
                                              ? playlistbox.put(
                                                  title,
                                                  dummylist,
                                                )
                                              : playlistbox;
                                          controller.update(["addplaylist"]);
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
                        SingleChildScrollView(
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
                                        (element) =>
                                            element['id'].toString().contains(
                                                  audio.metas.id.toString(),
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: TextButton(
                                        onPressed: () {
                                          controller.update(["addplaylist"]);
                                        },
                                        child: playlists
                                                .where((element) =>
                                                    element['id'].toString() ==
                                                    audio.metas.id.toString())
                                                .isEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  playlists.add(findsong.first);
                                                  playlistbox.put(
                                                      keys[ind], playlists);

                                                  controller
                                                      .update(["addplaylist"]);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                          'Song Added In Playlist'),
                                                      duration: const Duration(
                                                          seconds: 1),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Add to Playlist',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                
                                                  playlists.removeWhere(
                                                      (element) =>
                                                          element['id']
                                                              .toString() ==
                                                          findsong.first['id']
                                                              .toString());
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: const Text(
                                                          'Song Removed From Playlist'),
                                                      duration: const Duration(
                                                          seconds: 1),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Remove From Playlist',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
      icon: Icon(
        Icons.library_add,
        color: Colors.white,
      ),
    );
  }
}
