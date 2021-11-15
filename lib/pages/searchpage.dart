import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Search'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            trailing: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            tileColor: Colors.grey[800],
            title: Text(
              'Darshana',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            trailing: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            tileColor: Colors.grey[800],
            title: Text(
              'Darshana',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            trailing: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            tileColor: Colors.grey[800],
            title: Text(
              'Darshana',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
