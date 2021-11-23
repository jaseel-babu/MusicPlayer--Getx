import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicsample/functionalities/openPlayer.dart';
import 'package:musicsample/pages/playpage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class favoritesPage extends StatefulWidget {
  favoritesPage({Key? key}) : super(key: key);

  @override
  _favoritesPageState createState() => _favoritesPageState();
}

class _favoritesPageState extends State<favoritesPage> {
  @override
  void initState() {
    gettheme();
    super.initState();
  }

  String? theme;
  String? backimgpath;
  gettheme() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    theme = await sharedPref.getString('theme');
    setState(() {});
  }

  List<Audio> audio = [];
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
              elevation: 0,
              title: Text(
                'Favorites',
                style: Theme.of(context).textTheme.headline1,
              ),
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  keys[ind]['title'].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                leading: QueryArtworkWidget(
                  nullArtworkWidget:
                      Image.asset('assets/images/Neon Apple Music Logo.png'),
                  id: keys[ind]['id'],
                  type: ArtworkType.AUDIO,
                ),
                subtitle: Text(
                  keys[ind]['artist'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2,
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
