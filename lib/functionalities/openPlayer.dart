import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:musicsample/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenPlayer {
  bool? onOff;
  getChoice() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    onOff = await sharedPreferences.getBool(userOnOfNotification);
  
  }

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  void openPlayer(int index, List<Audio> audios) async {
    await getChoice();
   
    await assetsAudioPlayer.open(Playlist(audios: audios, startIndex: index),
        showNotification: onOff == null || onOff == true ? true : false,
        autoStart: true,
        loopMode: LoopMode.playlist,
        notificationSettings: NotificationSettings(stopEnabled: false));
  }
}
