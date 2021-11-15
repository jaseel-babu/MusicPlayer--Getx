// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:musicsample/database/playlist.dart';
// import 'package:musicsample/database/playlistmodel.dart';

// class PlaylistPage extends StatefulWidget {
//   String title;
//   Audio curindex;

//   PlaylistPage({
//     Key? key,
//     required this.title,
//     required this.curindex,
//   }) : super(key: key);

//   @override
//   _PlaylistPageState createState() => _PlaylistPageState();
// }

// class _PlaylistPageState extends State<PlaylistPage> {
//   // var playlist = Hive.box('playlist');
//   Box playlist = Hive.box('playlist');

//   int? a;
//   @override
//   void initState() {
//     super.initState();
//     // song.add(widget.curindex);
//   }

//   List<Audio> song = [];
//   @override
//   Widget build(BuildContext context) {
//     playlist.put(widget.title.toString(), widget.curindex);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           widget.title,
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(Icons.add),
//           )
//         ],
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: Hive.box('playlist').listenable(),
//         builder: (context, Box todos, _) {
//           // var keys = todos.keys.cast<int>().toList();
//           return ListView.separated(
//             itemCount: todos.length,
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               // final int key = keys[index];
//               final dynamic todo = todos.get(widget.title);
//               // a = b.get('title');
//               return todo == widget.curindex
//                   ? Text(
//                       'Its Allready in that playlist',
//                       style: TextStyle(color: Colors.white),
//                     )
//                   : GestureDetector(
//                       onTap: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => PlaylistPage(
//                         //       title: 'd',
//                         //       curindex: widget.curindex,
//                         //     ),
//                         //   ),
//                         // );
//                       },
//                       child: ListTile(
//                         title: todos.isEmpty
//                             ? Text(
//                                 "No",
//                                 style: TextStyle(color: Colors.white),
//                               )
//                             : Text(
//                                 todo.title[index].metas.title.toString(),
//                                 // widget.curindex.metas.title.toString(),
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                         trailing: IconButton(
//                           icon: Icon(
//                             Icons.delete,
//                             color: Colors.white,
//                           ),
//                           onPressed: () {
//                             todo.delete();
//                           },
//                         ),
//                       ),
//                     );
//             },
//             separatorBuilder: (_, index) => Divider(
//               color: Colors.white,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/database/playlistmodel.dart';
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
  List<dynamic> a = [];
  dynamic playlistbox = Hive.box('playlist');
  bool isUserPressed = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: widget.audios.length,
                                itemBuilder: (context, index) {
                                  int image = int.parse(
                                      widget.audios[index].metas.id.toString());
                                  return GestureDetector(
                                    onTap: () {
                                      List<dynamic> k = widget.audios
                                          .where((element) => element.id
                                              .toString()
                                              .contains(widget
                                                  .audios[index].metas.id
                                                  .toString()))
                                          .toList();
                                      a = playlistbox.get(widget.title);
                                      a.add(widget.audios[index]);
                                      print(a);
                                      playlistbox.put(widget.title, k.first);
                                    },
                                    child: ListTile(
                                      leading: QueryArtworkWidget(
                                        nullArtworkWidget: FlutterLogo(),
                                        id: image,
                                        type: ArtworkType.AUDIO,
                                      ),
                                      title: Text(
                                        widget.audios[index].metas.title
                                            .toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          isUserPressed = true;
                                          setState(() {});
                                          print('pressed');
                                        },
                                        icon: Icon(
                                          isUserPressed == true
                                              ? Icons.check_box_sharp
                                              : Icons.add,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
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
            )
          ],
        ),
      ),
    );
  }
}
