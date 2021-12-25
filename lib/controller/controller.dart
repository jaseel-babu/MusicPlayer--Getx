import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Controller extends GetxController {
  @override
  void onInit() {
    requestpermission();
    gettheme();
    getSwitchStatus();
    super.onInit();
  }

  final assetsAudioPlayer = AssetsAudioPlayer.withId('music');

  List<Audio> audio = [];
  List<SongModel> getsongs = [];
  List allsongsfromhive = [];
  List datasongs = [];
  Box databox = Hive.box('songbox');
  final OnAudioQuery _audioQuery = OnAudioQuery();
  Future<void> requestpermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }

    getsongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true);
    getsongs.forEach(
      (element) {
        datasongs.add(
          {
            'title': element.title,
            'artist': element.artist,
            'id': element.id,
            'uri': element.uri,
            'album': element.album,
            'duration': element.duration,
          },
        );

        databox.put('allsongs', datasongs);
        allsongsfromhive = databox.get('allsongs');
      },
    );
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
    update(['a']);
  }

  String? theme;
  String backimgpath = 'assets/images/fYV9z3.webp';
  gettheme() async {
    // -------------background image---------

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
    update();
  }

  int selectedIndex = 0;
  void onItemTapped(int index) {
    selectedIndex = index;
    update(["indexchange"]);
  }

  bool onOff = true;
  String? themename;
  getSwitchStatus() async {
    onOff = await getChoice();
    theme = await getnewtheme();
    update();
  }

  getnewtheme() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? theme = await sharedPref.getString('theme');
    return theme;
  }

  getChoice() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    bool? onOff = await sharedPreferences.getBool(userOnOfNotification);
    return onOff != null ? onOff : true;
  }
}
