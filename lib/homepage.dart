import 'package:flutter/material.dart';
import 'package:musicsample/pages/settings.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/library.dart';
import 'pages/searchpage.dart';
import 'pages/songlist.dart';

class HomePage extends StatefulWidget {
  final List<Audio> audio;
  HomePage({Key? key, required this.audio}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  @override
  void initState() {
    gettheme();
    super.initState();
  }

  String? theme;
  String backimgpath = 'assets/images/fYV9z3.webp';
  gettheme() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    theme = await sharedPref.getString('theme');
    if (theme == null ||
        theme == 'Background Image 1' ||
        theme == 'Change Background Image') {
      backimgpath = 'assets/images/fYV9z3.webp';
    } else if (theme == 'Background Image 2') {
      backimgpath = 'assets/images/darkper.jpg';
    } else if (theme == 'Background Image 3') {
      backimgpath = 'assets/images/_.jpeg';
    }
    setState(() {});
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
          image: new AssetImage(backimgpath),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Music Player',
              style: Theme.of(context).textTheme.headline1,
            ),
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
