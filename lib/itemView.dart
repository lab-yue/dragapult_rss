import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './feed.dart';

class ItemView extends StatelessWidget {
  FeedItem value;
  ItemView(this.value);
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
            onTap: () => _launchURL(value.link),
            child: Column(
              children: <Widget>[
                if (value.title != null)
                  ListTile(
                    title: Text(value.title ?? ""),
                  ),
                ListBody(
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              value.description,
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              value.feedTitle,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ))
                  ],
                ),
                Divider(
                  height: 2.0,
                ),
              ],
            )));
  }
}
