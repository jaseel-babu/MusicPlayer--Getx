import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive/hive.dart';
part 'playlistmodel.g.dart';

@HiveType(typeId: 1)
class DataModel extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late List<Audio> playlist;
}
