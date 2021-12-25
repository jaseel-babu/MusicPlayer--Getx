import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/controller/controller.dart';
import 'package:musicsample/pages/favoritePage.dart';
import 'package:musicsample/pages/playlistpage.dart';

class Library extends StatelessWidget {
  final List<Audio> audios;
  Library({Key? key, required this.audios}) : super(key: key);
  final controller = Get.put(Controller());
  var playlistbox = Hive.box('playlist');

  final TextEditingController namecontroller = TextEditingController();
  String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ListTile(
            title: GestureDetector(
              child: Text(
                '+ Create New Playlist',
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
                          var keys = playlistbox.keys.toList();

                          if (namecontroller != null) {
                            title = namecontroller.text;
                            keys.where((element) => element == title).isEmpty
                                ? title!.isNotEmpty
                                    ? playlistbox.put(
                                        title,
                                        dummylist,
                                      )
                                    : playlistbox
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'This name is already exist'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                            ;
                            controller.update(["edited"]);
                            Get.back();
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
          GestureDetector(
            onTap: () {
              Get.to(() => favoritesPage());
            },
            child: ListTile(
              tileColor: Colors.white30,
              title: Text('Favorites',
                  style: Theme.of(context).textTheme.bodyText1),
              trailing: Icon(Icons.favorite, color: Colors.white),
            ),
          ),
          GetBuilder<Controller>(builder: (Controller) {
            return ValueListenableBuilder(
              valueListenable: Hive.box('playlist').listenable(),
              builder: (context, Box playlistname, _) {
                //var keys = todos.keys.cast<int>().toList();
                return (ListView.separated(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: playlistname.keys.length,
                  shrinkWrap: true,
                  itemBuilder: (context, ind) {
                    return ListTile(
                      onTap: () {
                        Get.to(
                          () => playlistpage(
                              title: playlistname.keyAt(ind), audios: audios),
                        );
                      },
                      onLongPress: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
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
                                    hintText: playlistname.keyAt(ind),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    var y = playlistbox
                                        .get(playlistname.keyAt(ind));
                                    var keys = playlistbox.keys.toList();
                                    if (namecontroller.text.isNotEmpty) {
                                      title = namecontroller.text;
                                      keys
                                              .where(
                                                  (element) => element == title)
                                              .isEmpty
                                          ? title!.isNotEmpty
                                              ? playlistbox.put(
                                                  title,
                                                  y,
                                                )
                                              : playlistbox
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'This name is already exist'),
                                                duration:
                                                    const Duration(seconds: 1),
                                              ),
                                            );
                                      keys
                                              .where(
                                                  (element) => element == title)
                                              .isEmpty
                                          ? title!.isNotEmpty
                                              ? playlistbox.delete(
                                                  playlistname.keyAt(ind),
                                                )
                                              : playlistbox
                                          : playlistbox;
                                    }
                                    controller.update();
                                    Navigator.pop(context, 'OK');
                                    namecontroller.clear();
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
                        );
                      },
                      leading: Icon(
                        Icons.playlist_play,
                        color: Colors.white,
                      ),
                      title: playlistname.isEmpty
                          ? Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            )
                          : Text(
                              playlistname.keyAt(ind),
                              style: TextStyle(color: Colors.white),
                            ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          playlistname.deleteAt(ind);
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
          })
        ],
      ),
    );
  }
}
