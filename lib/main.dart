import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/database/datamodel.dart';
import 'package:musicsample/database/playlistmodel.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homepage.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  Hive.registerAdapter(PlaylistModelmyAdapter());
  // Hive.registerAdapter(playlistindexAdapter());
  // Hive.registerAdapter(FavoritesmodelAdapter());
  // await Hive.openBox('playlistindex');
  await Hive.openBox('playlist');
  await Hive.openBox('songbox');

  // await Hive.openBox('fovorites');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
    ),
  );
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer.withId('music');

  @override
  void initState() {
    super.initState();
    // requestpermission();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  // Future<void> requestpermission() async {
  //   bool permissionStatus = await _audioQuery.permissionsStatus();
  //   if (!permissionStatus) {
  //     await _audioQuery.permissionsRequest();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Image.asset('assets/images/logo.jpeg')),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Audio> audio = [];
  List<SongModel> getsongs = [];
  List allsongsfromhive = [];
  List datasongs = [];
  Box databox = Hive.box('songbox');
  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    super.initState();
    requestpermission();
  }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
              home: Splash(), debugShowCheckedModeBanner: false);
        } else {
          return HomePage(
            audio: audio,
          );
        }
      },
    );
  }
}
