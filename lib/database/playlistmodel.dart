import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive/hive.dart';
part 'playlistmodel.g.dart';

@HiveType(typeId: 1)
class PlaylistModelmy extends HiveObject {
  @HiveField(0)
  late dynamic title;

  PlaylistModelmy({required this.title});
}
