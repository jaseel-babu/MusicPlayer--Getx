import 'dart:async';
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
  String? theme;
  String? them;
  String? backimgpath;
  bool a = true;
  @override
  void initState() {
    super.initState();
    getSwitchStatus();
  }

  getSwitchStatus() async {
    onOff = await getChoice();
    theme = await gettheme();
    setState(() {});
  }

  setchoice(bool value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool(userOnOfNotification, value);
  }

  settheme(String value) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('theme', value);
  }

  gettheme() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? theme = await sharedPref.getString('theme');
    return theme;
  }

  getChoice() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    bool? onOff = await sharedPreferences.getBool(userOnOfNotification);
    return onOff != null ? onOff : true;
  }

  getstheme() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    them = await sharedPref.getString('theme');
  }

  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    if (theme == null ||
        theme == 'Background Image 1' ||
        theme == 'Change Background Image') {
      backimgpath = 'assets/images/fYV9z3.webp';
    } else if (theme == 'Background Image 2') {
      backimgpath = 'assets/images/darkper.jpg';
    } else if (theme == 'Background Image 3') {
      backimgpath = 'assets/images/_.jpeg';
    }

    String dropdownValue = 'Change Background Image';
    return Container(
      decoration: new BoxDecoration(
          image: new DecorationImage(
        image: new AssetImage(backimgpath!),
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
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Text('Notification',
                          style: Theme.of(context).textTheme.bodyText1),
                      trailing: Switch(
                        activeColor: Colors.grey,
                        value: onOff,
                        onChanged: (value) {
                          setState(
                            () {
                              onOff = value;
                              setchoice(value);
                              print(value);
                              if (a) {
                                a = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Notification will be On/Off in Next Restart'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                                Timer(Duration(seconds: 2), () {
                                  a = true;
                                });
                              }
                            },
                          );
                        },
                        inactiveTrackColor: Colors.white,
                        activeTrackColor: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 50),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Colors.black,
                          value: dropdownValue,
                          icon: const Icon(
                            Icons.wallpaper,
                            color: Colors.white,
                          ),
                          style: const TextStyle(color: Colors.deepPurple),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                              settheme(newValue);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'It will be Changed in Next Restart'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            });
                          },
                          items: <String>[
                            'Change Background Image',
                            'Background Image 1',
                            "Background Image 2",
                            'Background Image 3'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: Theme.of(context).textTheme.bodyText1),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Text('Privacy and Policy',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    ListTile(
                        leading: Text('Terms And Conditions',
                            style: Theme.of(context).textTheme.bodyText1)),
                    ListTile(
                      onTap: () => showAboutDialog(
                          applicationLegalese:
                              "Musicus its a Offline Music Player Created by Jaseel Babu.It's the First version of this App",
                          applicationIcon: Image.asset(
                            'assets/images/AppLogo.png',
                            width: 50,
                            height: 50,
                          ),
                          context: context,
                          applicationName: 'Musicus',
                          applicationVersion: '1.0.0'),
                      leading: Text('About',
                          style: Theme.of(context).textTheme.bodyText1),
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
