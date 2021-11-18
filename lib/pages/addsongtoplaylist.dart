// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:musicsample/database/playlistmodel.dart';
// import 'package:musicsample/pages/playlistpage.dart';

// class AddLibrary extends StatefulWidget {
//   Audio currentindex;
//   List<Audio> audio;
//   AddLibrary({Key? key, required this.currentindex, required this.audio})
//       : super(key: key);

//   @override
//   _AddLibraryState createState() => _AddLibraryState();
// }

// class _AddLibraryState extends State<AddLibrary> {
//   List<dynamic>? k;
//   List<Audio> audio = [];
//   List<dynamic> a = [];
//   dynamic playlistbox = Hive.box('playlist');
//   List<dynamic> b = [];
//   @override
//   void initState() {
//     super.initState();
//   }

//   final TextEditingController namecontroller = TextEditingController();

//   // list() async => playlist = await Hive.openBox('playlist');
//   @override
//   Widget build(BuildContext context) {
//     var a = playlistbox.get("title");
//     String? title;
//     // int lastindex = widget.currentindex;
//     // var a = playlistbox.get("title");
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text("Add song into this playlists"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView(
//           children: [
//             ListTile(
//               title: GestureDetector(
//                 child: Text(
//                   '+ Add Playlist',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () => showDialog<String>(
//                     context: context,
//                     builder: (BuildContext context) {
//                       List<dynamic> dummylist = [];
//                       return AlertDialog(
//                         backgroundColor: Colors.black,
//                         title: Text(
//                           'Create New Playlist',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                         actions: [
//                           TextField(
//                             controller: namecontroller,
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(),
//                               hintText: 'Playlist Name',
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () async {
//                               // print(namecontroller);
//                               if (namecontroller != null) {
//                                 title = namecontroller.text;
//                                 // PlaylistModelmy playlist =
//                                 // PlaylistModelmy(title: title);
//                                 title != null
//                                     ? playlistbox.put(
//                                         title,
//                                         dummylist,
//                                       )
//                                     : playlistbox;
//                                 setState(() {});
//                                 Navigator.pop(context, 'OK');
//                                 namecontroller.clear();
//                               }
//                             },
//                             child: const Text(
//                               'OK',
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     }),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 // playlistbox.clear();
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => Favorites(
//                 //       audios: widget.audios,
//                 //       title: 'Favorites',
//                 //     ),
//                 //   ),
//                 // );
//                 List<dynamic> dummylist = [];
//               },
//               child: ListTile(
//                 tileColor: Colors.white30,
//                 title: a == null
//                     ? Text(
//                         'Favorites',
//                         style: TextStyle(color: Colors.white),
//                       )
//                     : Text(
//                         a.title,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                 trailing: Icon(Icons.favorite, color: Colors.white),
//               ),
//             ),
//             playlistbox == null
//                 ? Text(
//                     'No Data here now',
//                     style: TextStyle(color: Colors.white),
//                   )
//                 : ValueListenableBuilder(
//                     valueListenable: Hive.box('playlist').listenable(),
//                     builder: (context, Box todos, _) {
//                       Box databox = Hive.box('songbox');
//                       var allsongsfromhive = databox.get('allsongs');
//                       print(allsongsfromhive[0]['id']);
//                       //var keys = todos.keys.cast<int>().toList();
//                       return (ListView.separated(
//                         physics: ScrollPhysics(),
//                         scrollDirection: Axis.vertical,
//                         itemCount: todos.keys.length,
//                         shrinkWrap: true,
//                         itemBuilder: (context, ind) {
//                           //final int key = keys[index];
//                           var todo = todos.get(title.toString());
//                           // a = b.get('title');
//                           return GestureDetector(
//                             onTap: () {
//                               k = allsongsfromhive
//                                   .where((element) => element['id']
//                                       .toString()
//                                       .contains(widget.audio[ind].metas.id
//                                           .toString()))
//                                   .toList();
//                               a = playlistbox.get(title);
//                               a.add(k!.first);

//                               playlistbox.put(title, a);
//                               print(a);

//                               setState(() {});
//                             },
//                             child: GestureDetector(
//                               onTap: () {
//                                 playlistpage(
//                                   audios: widget.audio,
//                                   title: todos.keyAt(ind),
//                                 );
//                                 setState(() {});
//                                 // Navigator.push(
//                                 //     context,
//                                 //     MaterialPageRoute(
//                                 //         builder: (context) => playlistpage(
//                                 //               audios: widget.audio,
//                                 //               title: todos.keyAt(ind),
//                                 //             )));
//                               },
//                               child: ListTile(
//                                 leading: Icon(
//                                   Icons.playlist_play,
//                                   color: Colors.white,
//                                 ),
//                                 title: todos.isEmpty
//                                     ? Text(
//                                         "No",
//                                         style: TextStyle(color: Colors.white),
//                                       )
//                                     : Text(
//                                         todos.keyAt(ind),
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                 trailing: IconButton(
//                                   icon: Icon(
//                                     Icons.delete,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () {
//                                     todos.deleteAt(ind);
//                                   },
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         separatorBuilder: (_, index) => Divider(
//                           color: Colors.white,
//                         ),
//                       ));
//                     },
//                   )
//           ],
//         ),
//       ),
//     );
//   }
// }
