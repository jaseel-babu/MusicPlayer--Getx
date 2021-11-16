import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/pages/playpage.dart';

class SearchPage extends StatefulWidget {
  List<Audio> audios;

  SearchPage({
    Key? key,
    required this.audios,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  void openPlayer(
    int index,
  ) async {
    await assetsAudioPlayer.open(
        Playlist(audios: widget.audios, startIndex: index),
        showNotification: true,
        autoStart: true,
        notificationSettings: NotificationSettings(stopEnabled: false));
  }

  String searchText = "";
  List<Audio> xt = [];
  TextEditingController searchcontroll = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<Audio> result = searchText == ''
        ? xt.toList()
        : widget.audios
            .where(
              (element) => element.metas.title!.toLowerCase().contains(
                    searchText.toLowerCase(),
                  ),
            )
            .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              Future.delayed(Duration(seconds: 2), () {
                setState(
                  () {
                    searchText = value;
                  },
                );
              });
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Search'),
          ),
        ),

        result.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    print(result);
                    return GestureDetector(
                      onTap: () {
                        openPlayer(index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayPage(audio: widget.audios, index: index),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          result[index].metas.title.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              )
            : SizedBox()

        // Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child: ListTile(
        //     trailing: Icon(
        //       Icons.play_arrow,
        //       color: Colors.white,
        //     ),
        //     tileColor: Colors.grey[800],
        //     title: Text(
        //       'Darshana',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child: ListTile(
        //     trailing: Icon(
        //       Icons.play_arrow,
        //       color: Colors.white,
        //     ),
        //     tileColor: Colors.grey[800],
        //     title: Text(
        //       'Darshana',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child: ListTile(
        //     trailing: Icon(
        //       Icons.play_arrow,
        //       color: Colors.white,
        //     ),
        //     tileColor: Colors.grey[800],
        //     title: Text(
        //       'Darshana',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
