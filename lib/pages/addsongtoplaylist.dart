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
//   List<dynamic> b = [];
//   @override
//   void initState() {
//     super.initState();
//   }

//   var playlistbox = Hive.box('playlist');

//   final TextEditingController namecontroller = TextEditingController();

//   // list() async => playlist = await Hive.openBox('playlist');
//   @override
//   Widget build(BuildContext context) {
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
//                   context: context,
//                   builder: (BuildContext context) => AlertDialog(
//                     backgroundColor: Colors.black,
//                     title: Text(
//                       'Create New Playlist',
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     actions: [
//                       TextField(
//                         controller: namecontroller,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(),
//                           hintText: 'Playlist Name',
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () async {
//                           // print(namecontroller);
//                           title = namecontroller.text;
//                           // PlaylistModelmy playlist =
//                           //     PlaylistModelmy(title: title);
//                           playlistbox.put(title, b);
//                           setState(() {});
//                           Navigator.pop(context, 'OK');
//                           namecontroller.clear();
//                         },
//                         child: const Text(
//                           'OK',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: ListTile(
//                 tileColor: Colors.white30,
//                 title: Text(
//                   'Favorites',
//                   style: TextStyle(color: Colors.white),
//                 ),
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
//                       // var keys = todos.keys.cast<int>().toList();
//                       return ListView.separated(
//                         itemCount: todos.length,
//                         shrinkWrap: true,
//                         itemBuilder: (context, ind) {
//                           // // final int key = keys[index];
//                           final PlaylistModelmy? todo =
//                               todos.get(title.toString());
//                           // a = b.get('title');
//                           return GestureDetector(
//                             onTap: () {
//                               // Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => PlaylistPage(
//                               //               // curindex: lastindex,
//                               //               title: todos.keyAt(ind).toString(),
//                               //               curindex: widget.audio[ind],
//                               //             )));
//                             },
//                             child: GestureDetector(
//                               onTap: () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => PlaylistPage(
//                                 //         // curindex: widget.currentindex,
//                                 //         // title: todos.keyAt(ind).toString(),
//                                 //         ),
//                                 //   ),
//                                 // );
//                               },
//                               child: ListTile(
//                                 title: todos.isEmpty
//                                     ? Text(
//                                         "No",
//                                         style: TextStyle(color: Colors.white),
//                                       )
//                                     : Text(
//                                         todos.keyAt(ind).toString(),
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
//                       );
//                     },
//                   )
//           ],
//         ),
//       ),
//     );
//   }
// }
