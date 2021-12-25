import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:musicsample/controller/controller.dart';

class FavoriteButton extends StatelessWidget {
  final Audio myAudio;
  FavoriteButton({Key? key, required this.myAudio}) : super(key: key);

  final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    var favoritesbox = Hive.box('fav');
    List<dynamic> favlists = favoritesbox.get('favsong');
    return IconButton(
      icon: favlists
              .where((element) =>
                  element['id'].toString() == myAudio.metas.id.toString())
              .isEmpty
          ? Icon(
              Icons.favorite_border,
              color: Colors.white,
            )
          : Icon(
              Icons.favorite,
              color: Colors.white,
            ),
      onPressed: () {
        Box databox = Hive.box('songbox');
        var allsongsfromhive = databox.get('allsongs');
        List<dynamic> findsong = allsongsfromhive
            .where(
              (element) => element['id'].toString().contains(
                    myAudio.metas.id.toString().toString(),
                  ),
            )
            .toList();

        favlists
                .where((element) =>
                    element['id'].toString() ==
                    myAudio.metas.id.toString().toString())
                .isEmpty
            ? favlists.add(findsong.first)
            : favlists.removeWhere((element) =>
                element['id'].toString() ==
                myAudio.metas.id.toString().toString());
        favoritesbox.put('favsong', favlists);
      
        controller.update(["fav"]);
      },
    );
  }
}
