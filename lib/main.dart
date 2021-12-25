import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicsample/controller/controller.dart';
import 'package:musicsample/database/datamodel.dart';
import 'package:musicsample/database/favorites.dart';
import 'package:musicsample/database/playlistmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homepage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const String userOnOfNotification = 'isUserChoice';
Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  Hive.registerAdapter(PlaylistModelmyAdapter());
  Hive.registerAdapter(FavoritesmodelAdapter());
  await Hive.openBox('playlist');
  await Hive.openBox('songbox');
  await Hive.openBox('fav');
  var favoritesbox = Hive.box('fav');

  List<dynamic>? c = favoritesbox.keys.toList();
  if (c.isEmpty) {
    List<dynamic> dummy = [];
    favoritesbox.put('favsong', dummy);
  }
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
              fontFamily: 'Georgia'),
          headline2: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto'),
          headline3: TextStyle(
              color: Colors.white70,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto'),
          bodyText1: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto'),
          bodyText2: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w200,
              fontFamily: 'Georgia'),
        ),
      ),
    ),
  );
}

class Splash extends StatelessWidget {
  Splash({Key? key}) : super(key: key);

  final assetsAudioPlayer = AssetsAudioPlayer.withId('music');

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/AppLogo.png',
          height: 180,
          width: 150,
        ),
      ),
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
  MyApp({Key? key}) : super(key: key);

  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
   
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: Splash(), debugShowCheckedModeBanner: false);
        } else {
          return GetBuilder<Controller>(
            id: "a",
            builder: (contrl) {
              return HomePage(
                audio: contrl.audio,
              );
            },
          );
        }
      },
    );
  }
}
