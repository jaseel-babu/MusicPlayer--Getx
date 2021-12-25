import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:musicsample/functionalities/openPlayer.dart';
import 'package:musicsample/functionalities/popupmenu.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'playpage.dart';

class Songlist extends StatelessWidget {
  final List<Audio> audios;

  Songlist({
    Key? key,
    required this.audios,
  }) : super(key: key);

  List<dynamic>? k;
  List<Audio>? audio = [];
  List<dynamic>? a = [];

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  Audio? myAudio;
  var ind = 0;
  @override
  Widget build(BuildContext context) {
    return audios.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: audios.length,
                        itemBuilder: (context, index) {
                          ind = index;
                          var image =
                              int.parse(audios[index].metas.id.toString());
                          return GestureDetector(
                            onTap: () {
                              OpenPlayer().openPlayer(index, audios);
                              Get.to(
                                () => PlayPage(audio: audios, index: index),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 140,
                                      child: QueryArtworkWidget(
                                        artworkBorder:
                                            BorderRadius.circular(40),
                                        nullArtworkWidget: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          width: 120,
                                          height: 110,
                                          child: Container(
                                            width: 120,
                                            height: 110,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/Neon Apple Music Logo.png'),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        id: image,
                                        type: ArtworkType.AUDIO,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                                audios[index].metas.title!,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3),
                                          ),
                                          Popupmenu(
                                              audios: audios, index: index)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ),
              RecentlyPlayed()
            ],
          );
  }

  PlayerBuilder RecentlyPlayed() {
    return assetsAudioPlayer.builderCurrent(
      builder: (context, Playing? playing) {
        myAudio = find(audios, playing!.audio.assetAudioPath);
        var image = int.parse(myAudio!.metas.id!);
        return Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Now Playing',
                  style: TextStyle(
                      color: Colors.white60,
                      fontSize: 18,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => PlayPage(audio: audios, index: 0),
                    );
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                    ),
                    child: ListTile(
                      leading: QueryArtworkWidget(
                        nullArtworkWidget: Image.asset(
                            'assets/images/Neon Apple Music Logo.png'),
                        id: image,
                        type: ArtworkType.AUDIO,
                      ),
                      title: Text(myAudio!.metas.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1),
                      subtitle: Text(myAudio!.metas.artist!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2),
                      trailing: PlayerBuilder.isPlaying(
                        player: assetsAudioPlayer,
                        builder: (context, isPlaying) {
                          return IconButton(
                            onPressed: () async {
                              await assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
