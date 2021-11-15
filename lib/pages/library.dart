import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/database/playlistmodel.dart';
import 'package:musicsample/pages/favoritePage.dart';
import 'package:musicsample/pages/playlistpage.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Library extends StatefulWidget {
  List<Audio> audios;
  Library({Key? key, required this.audios}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  void initState() {
    super.initState();
  }

  var playlistbox = Hive.box('playlist');

  final TextEditingController namecontroller = TextEditingController();
  String? title;
  // list() async => playlist = await Hive.openBox('playlist');
  @override
  Widget build(BuildContext context) {
    // var a = playlistbox.get("title");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
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
                            // print(namecontroller);
                            if (namecontroller != null) {
                              title = namecontroller.text;
                              // PlaylistModelmy playlist =
                              // PlaylistModelmy(title: title);
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
                  }),
            ),
          ),
          GestureDetector(
            onTap: () {
              playlistbox.clear();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favorites(
                    audios: widget.audios,
                    title: 'Favorites',
                  ),
                ),
              );
              List<dynamic> dummylist = [];
            },
            child: ListTile(
              tileColor: Colors.white30,
              title: Text(
                'Favorites',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.favorite, color: Colors.white),
            ),
          ),
          playlistbox == null
              ? Text(
                  'No Data here now',
                  style: TextStyle(color: Colors.white),
                )
              : ValueListenableBuilder(
                  valueListenable: Hive.box('playlist').listenable(),
                  builder: (context, Box todos, _) {
                    //var keys = todos.keys.cast<int>().toList();
                    return (ListView.separated(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: todos.keys.length,
                      shrinkWrap: true,
                      itemBuilder: (context, ind) {
                        //final int key = keys[index];
                        var todo = todos.get(title.toString());
                        // a = b.get('title');
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => playlistpage(
                                          audios: widget.audios,
                                          title: todos.keyAt(ind),
                                        )));
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.playlist_play,
                              color: Colors.white,
                            ),
                            title: todos.isEmpty
                                ? Text(
                                    "No",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    todos.keyAt(ind),
                                    style: TextStyle(color: Colors.white),
                                  ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                todos.deleteAt(ind);
                              },
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, index) => Divider(
                        color: Colors.white,
                      ),
                    ));
                  },
                )
        ],
      ),
    );
  }
}
