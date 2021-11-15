import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/database/favorites.dart';
import 'package:musicsample/database/playlist.dart';

class Favorites extends StatefulWidget {
  String title;
  int? curindex;
  List<Audio> audios;
  Favorites({required this.audios, this.title = '', this.curindex});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  var playlistind = Hive.box('fovorites');

  int? a;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.curindex == null
    //     ? playlistind
    //     :

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                playlistind.clear();
              },
              child: Text(
                'Clear All',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // IconButton(
          //     onPressed: () {
          //       playlistind.clear();
          //     },
          //     icon: Icon(
          //       Icons.delete,
          //       color: Colors.white,
          //     ))
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('fovorites').listenable(),
        builder: (context, Box todos, _) {
          var keys = todos.keys.cast<int>().toList();
          return ListView.separated(
            itemCount: todos.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final int key = keys[index];
              final Favoritesmodel? todo = todos.get(key);
              // a = b.get('title');
              return todo == widget.curindex
                  ? Text(
                      'Its Allready in that playlist',
                      style: TextStyle(color: Colors.white),
                    )
                  : GestureDetector(
                      onTap: () {},
                      child: ListTile(
                        title: todos.isEmpty
                            ? Text(
                                "No",
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                widget.audios[todo!.index].metas.title
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            todo!.delete();
                          },
                        ),
                      ));
            },
            separatorBuilder: (_, index) => Divider(
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
