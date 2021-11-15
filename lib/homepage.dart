import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/pages/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'pages/library.dart';
import 'pages/searchpage.dart';
import 'pages/songlist.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  @override
  void initState() {
    super.initState();

    getSongs();
  }

  List<Audio> audio = [];
  List<SongModel> getsongs = [];
  List allsongsfromhive = [];
  List datasongs = [];
  getSongs() async {
    Box databox = await Hive.openBox('songbox');

    getsongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true);
    getsongs.forEach((element) {
      datasongs.add({
        'title': element.title,
        'artist': element.artist,
        'id': element.id,
        'uri': element.uri,
        'album': element.album,
        'duration': element.duration,
      });
      databox.put('allsongs', datasongs);
      allsongsfromhive = databox.get('allsongs');
    });
    for (var i = 0; i <= allsongsfromhive.length - 1; i++) {
      var newaudio = Audio.file(
        allsongsfromhive[i]['uri'].toString(),
        metas: Metas(
          id: allsongsfromhive[i]['id'].toString(),
          title: allsongsfromhive[i]['title'],
          album: allsongsfromhive[i]['album'],
          artist: allsongsfromhive[i]['artist'],
          image: MetasImage.file(
            allsongsfromhive[i]['uri'].toString(),
          ),
        ),
      );
      audio.add(newaudio);
    }
    setState(() {});
  }

  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void openPlayer(
    int index,
  ) async {
    await assetsAudioPlayer.open(Playlist(audios: audio, startIndex: index),
        showNotification: true,
        autoStart: true,
        notificationSettings: NotificationSettings(stopEnabled: false));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOption = [
      Songlist(
        audios: audio,
        openPlayer: openPlayer,
      ),
      SearchPage(),
      Library(
        audios: audio,
      )
    ];
    // getSongs();
    // print(audio);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Music Player Sample'),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ],
        ),
        body: _widgetOption[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.library_music,
                color: Colors.white,
              ),
              label: 'Library',
            ),
          ],
          onTap: onItemTapped,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
        ),
      ),
    );
  }
}
