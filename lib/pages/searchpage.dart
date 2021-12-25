import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicsample/controller/controller.dart';
import 'package:musicsample/functionalities/openPlayer.dart';
import 'package:musicsample/pages/playpage.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchPage extends StatelessWidget {
  final List<Audio> audios;

  SearchPage({
    Key? key,
    required this.audios,
  }) : super(key: key);

  final controller = Get.put(Controller());

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  String searchText = "";
  List<Audio> dummy = [];

  TextEditingController searchcontroll = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            onChanged: (value) {
              Future.delayed(
                Duration(seconds: 2),
                () {
                  searchText = value;
                  controller.update(["results"]);
                 
                },
              );
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Search'),
          ),
        ),
        Expanded(
          child: GetBuilder<Controller>(
            id: "results",
            builder: (controller) {
              List<Audio> result = searchText == ''
                  ? dummy.toList()
                  : audios
                      .where(
                        (element) =>
                            element.metas.title!.toLowerCase().contains(
                                  searchText.toLowerCase(),
                                ),
                      )
                      .toList();
              return ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      OpenPlayer().openPlayer(index, result);
                      Get.to(() => PlayPage(audio: result, index: index));
                    },
                    child: ListTile(
                      leading: QueryArtworkWidget(
                        nullArtworkWidget: Image.asset(
                            'assets/images/Neon Apple Music Logo.png'),
                        id: int.parse(result[index].metas.id.toString()),
                        type: ArtworkType.AUDIO,
                      ),
                      title: Text(result[index].metas.title.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1),
                      subtitle: Text(result[index].metas.artist.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2),
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
              );
            },
          ),
        ),
      ],
    );
  }
}
