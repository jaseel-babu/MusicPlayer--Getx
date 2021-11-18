import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/pages/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'pages/library.dart';
import 'pages/searchpage.dart';
import 'pages/songlist.dart';

class HomePage extends StatefulWidget {
  List<Audio> audio;
  HomePage({Key? key, required this.audio}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  int _selectedIndex = 0;

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  @override
  void initState() {
    super.initState();

    // requestpermission();
    // getSongs();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void openPlayer(
    int index,
  ) async {
    await assetsAudioPlayer.open(
        Playlist(audios: widget.audio, startIndex: index),
        showNotification: true,
        autoStart: true,
        notificationSettings: NotificationSettings(stopEnabled: false));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOption = [
      Songlist(
        audios: widget.audio,
        openPlayer: openPlayer,
      ),
      SearchPage(
        audios: widget.audio,
      ),
      Library(
        audios: widget.audio,
      )
    ];
    // getSongs();
    // print(audio);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Music Player'),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
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
