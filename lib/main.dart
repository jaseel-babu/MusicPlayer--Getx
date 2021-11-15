import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/database/datamodel.dart';
import 'package:musicsample/database/favorites.dart';
import 'package:musicsample/database/playlistmodel.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homepage.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  Hive.registerAdapter(PlaylistModelmyAdapter());
  // Hive.registerAdapter(playlistindexAdapter());
  Hive.registerAdapter(FavoritesmodelAdapter());
  // await Hive.openBox('playlistindex');
  await Hive.openBox('playlist');
  await Hive.openBox('fovorites');
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
  final assetsAudioPlayer = AssetsAudioPlayer.withId('0');

  @override
  void initState() {
    super.initState();
    requestpermission();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  Future<void> requestpermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor:
          lightMode ? const Color(0xffe1f5fe) : const Color(0xff042a49),
      body: Center(child: FlutterLogo()),
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(home: Splash());
          } else {
            return HomePage();
          }
        });
  }
}
