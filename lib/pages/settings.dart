import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_drop_down_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Text(
              'Notification',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            trailing: Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(
                  () {
                    isSwitched = value;
                    assetsAudioPlayer.showNotification = true;
                  },
                );
              },
              inactiveTrackColor: Colors.white,
              activeTrackColor: Colors.white,
            ),
          ),
          ListTile(
            onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Music app',
                applicationVersion: '1.0.0'),
            leading: Text(
              'About',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
