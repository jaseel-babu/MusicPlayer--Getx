import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicsample/controller/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicsample/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final controller = Get.put(Controller());

  String? them;
  String? backimgpath;
  bool a = true;

  setchoice(bool value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool(userOnOfNotification, value);
  }

  settheme(String value) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('theme', value);
  }

  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    if (controller.theme == null ||
        controller.theme == 'Background Image 1' ||
        controller.theme == 'Change Background Image') {
      backimgpath = 'assets/images/fYV9z3.webp';
    } else if (controller.theme == 'Background Image 2') {
      backimgpath = 'assets/images/darkper.jpg';
    } else if (controller.theme == 'Background Image 3') {
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
            onPressed: () => Get.back(),
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
                      trailing: GetBuilder<Controller>(
                        id: "Switch",
                        builder: (controller) {
                          return Switch(
                            activeColor: Colors.grey,
                            value: controller.onOff,
                            onChanged: (value) {
                              controller.onOff = value;
                              setchoice(value);
                             
                              if (a) {
                                a = false;
                                Get.snackbar(
                                  "",
                                  'Notification will be On/Off in Next Restart',
                                  colorText: Colors.white,
                                  backgroundColor: Colors.transparent,
                                  duration: Duration(seconds: 1),
                                  snackPosition: SnackPosition.BOTTOM,
                                );

                                Timer(Duration(seconds: 2), () {
                                  a = true;
                                });
                              }
                              controller.update(["Switch"]);
                            },
                            inactiveTrackColor: Colors.white,
                            activeTrackColor: Colors.white,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 50),
                      child: DropdownButtonHideUnderline(
                        child: GetBuilder<Controller>(
                            id: "bg",
                            builder: (controller) {
                              return DropdownButton<String>(
                                dropdownColor: Colors.black,
                                value: dropdownValue,
                                icon: const Icon(
                                  Icons.wallpaper,
                                  color: Colors.white,
                                ),
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                onChanged: (String? newValue) {
                                  dropdownValue = newValue!;
                                  settheme(newValue);
                                  Get.snackbar(
                                    "",
                                    "It will be Changed in Next Restart",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.black87,
                                    duration: Duration(seconds: 1),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  controller.update(["bg"]);
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  );
                                }).toList(),
                              );
                            }),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        _launchURL();
                      },
                      leading: Text('Privacy and Policy',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    ListTile(
                        leading: Text('Terms And Conditions',
                            style: Theme.of(context).textTheme.bodyText1)),
                    ListTile(
                        onTap: () {
                          Share.share(
                              'Download Simple Music Player https://play.google.com/store/apps/details?id=com.jaseel.musicusmusicplayer');
                        },
                        leading: Text('Share',
                            style: Theme.of(context).textTheme.bodyText1)),
                    ListTile(
                      onTap: () => showAboutDialog(
                        applicationIcon: Image.asset(
                          'assets/images/AppLogo.png',
                          width: 50,
                          height: 50,
                        ),
                        context: context,
                        applicationName: 'Musicus',
                        applicationVersion: '2.0.0',
                        children: [
                          const Text(
                              "Musicus its a Offline Music Player Created by Jaseel Babu.It's the Second version of this App"),
                        ],
                      ),
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
                  'Version 2.0.0',
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

  void _launchURL() async {
    if (!await launch("https://sites.google.com/view/musicus"))
      throw 'Could not launch';
  }
}
