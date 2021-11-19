import 'package:assets_audio_player/assets_audio_player.dart';

class OpenPlayer {
  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');
  void openPlayer(int index, List<Audio> audios) async {
    await assetsAudioPlayer.open(Playlist(audios: audios, startIndex: index),
        showNotification: true,
        autoStart: true,
        notificationSettings: NotificationSettings(stopEnabled: false));
  }
}
