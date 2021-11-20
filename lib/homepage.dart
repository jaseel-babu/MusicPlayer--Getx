import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/pages/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOption = [
      Songlist(
        audios: widget.audio,
      ),
      SearchPage(
        audios: widget.audio,
      ),
      Library(
        audios: widget.audio,
      )
    ];

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
            title: Text('Music Player'),
            backgroundColor: Colors.transparent,
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
      ),
    );
  }
}
