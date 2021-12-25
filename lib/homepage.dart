import 'package:flutter/material.dart';
import 'package:musicsample/controller/controller.dart';
import 'package:musicsample/pages/settings.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'pages/library.dart';
import 'pages/searchpage.dart';
import 'pages/songlist.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final List<Audio> audio;
  HomePage({Key? key, required this.audio}) : super(key: key);

  final controller = Get.put(Controller());
  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOption = [
      Songlist(
        audios: audio,
      ),
      SearchPage(
        audios: audio,
      ),
      Library(
        audios: audio,
      )
    ];

    return SafeArea(
      child: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage(controller.backimgpath),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Musicus',
              style: Theme.of(context).textTheme.headline1,
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Get.to(() => SettingsPage());
                  }),
            ],
          ),
          body: GetBuilder<Controller>(
            id: "indexchange",
            builder: (controller) {
              return _widgetOption[controller.selectedIndex];
            },
          ),
          bottomNavigationBar: GetBuilder<Controller>(
            id: "indexchange",
            builder: (contrl) {
              return BottomNavigationBar(
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
                onTap: contrl.onItemTapped,
                currentIndex: contrl.selectedIndex,
                selectedItemColor: Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }
}
