import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/functionalities/openPlayer.dart';
import 'package:musicsample/pages/playpage.dart';
import 'package:on_audio_query/on_audio_query.dart';

class favoritesPage extends StatefulWidget {
  favoritesPage({Key? key}) : super(key: key);

  @override
  _favoritesPageState createState() => _favoritesPageState();
}

class _favoritesPageState extends State<favoritesPage> {
  List<Audio> audio = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage('assets/images/fYV9z3.webp'),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              title: Text('Favorites'),
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [favlist()],
              ),
            )),
      ),
    );
  }

  ValueListenableBuilder<Box<dynamic>> favlist() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('fav').listenable(),
      builder: (context, Box todos, _) {
        audio = [];
        List<dynamic> keys = todos.get('favsong');
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
            return ListTile(
              title: Text(
                // 'ga',
                keys[ind]['title'].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: QueryArtworkWidget(
                nullArtworkWidget:
                    Image.asset('assets/images/defaultImage.jpg'),
                id: keys[ind]['id'],
                type: ArtworkType.AUDIO,
              ),
              subtitle: Text(
                keys[ind]['artist'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onTap: () {
                OpenPlayer().openPlayer(ind, audio);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayPage(audio: audio, index: ind),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  keys.removeAt(ind);
                  setState(() {});
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
  }
}
