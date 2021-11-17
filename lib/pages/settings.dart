import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isSwitched = true;
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
                setState(() {});
              },
              inactiveTrackColor: Colors.white,
              activeTrackColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Text(
              'Privacy and Policy',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ListTile(
            leading: Text(
              'Terms And Conditions',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () => showAboutDialog(
                applicationIcon: Image.asset(
                  'assets/images/logo.jpeg',
                  width: 50,
                  height: 50,
                ),
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
