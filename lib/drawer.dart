import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Text("Dragapult RSS"),
          ),
          new ListTile(
            title: new Text("Feed"),
            onTap: () {
              Navigator.pop(context);
              //   Navigator.push(context,
              //       new MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),
          new ListTile(
            title: new Text("Read"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          new ListTile(
            title: new Text("Star"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
