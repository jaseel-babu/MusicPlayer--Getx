import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicsample/main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool onOff = true;

  @override
  void initState() {
    super.initState();
    getSwitchStatus();
  }

  getSwitchStatus() async {
    onOff = await getChoice();

    setState(() {});
  }

  setchoice(bool value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool(userOnOfNotification, value);
    // return sharedPreferences.setBool(userOnOfNotification, value);
  }

  getChoice() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    bool? onOff = await sharedPreferences.getBool(userOnOfNotification);
    return onOff != null ? onOff : true;
  }

  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          image: new DecorationImage(
        image: new AssetImage('assets/images/fYV9z3.webp'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_drop_down_outlined),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Settings'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Text(
                        'Notification',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      trailing: Switch(
                        value: onOff,
                        onChanged: (value) {
                          setState(
                            () {
                              onOff = value;
                              setchoice(value);
                              print(value);
                            },
                          );
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
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
