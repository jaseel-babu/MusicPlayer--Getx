import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/functionalities/openPlayer.dart';
import 'package:musicsample/pages/playpage.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
                setState(() {});
                searchText = value;
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
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    print(result);
                    return GestureDetector(
                      onTap: () {
                        OpenPlayer().openPlayer(index, widget.audios);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayPage(audio: widget.audios, index: index),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: QueryArtworkWidget(
                          nullArtworkWidget:
                              Image.asset('assets/images/defaultImage.jpg'),
                          id: int.parse(result[index].metas.id.toString()),
                          type: ArtworkType.AUDIO,
                        ),
                        title: Text(
                          result[index].metas.title.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          result[index].metas.artist.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white,
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
