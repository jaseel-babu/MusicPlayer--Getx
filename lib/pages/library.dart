import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  Library({Key? key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        // scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        children: [
          ListTile(
            title: GestureDetector(
              child: Text(
                '+ Add Playlist',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.black,
                  title: Text(
                    'Create New Playlist',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: 'Playlist Name',
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print('pressed');
            },
            child: ListTile(
              tileColor: Colors.white30,
              title: Text(
                'Favorites',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
