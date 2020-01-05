import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
//import 'dart:developer' as developer;
//import 'package:webfeed/webfeed.dart';
import './dummy.dart' as dummy;
import './helper.dart' as helper;

const List<String> feedList = [
  'https://news.vuejs.org/feed.xml',
  'https://coolshell.cn/feed'
];

Future<List<FeedItem>> fetch() async {
  //var res = await http.get(feedList[0]);
  //var rssFeed = new RssFeed.parse(res.body);
  var res = [dummy.vueFeed, dummy.coolSheelFeed];
  var rssFeed = res.expand((f) => (new RssFeed.parse(f).items));
  return rssFeed.map(formatRssItem).toList();
}

String formatRssItemText(String text) {
  text = helper.removeAllHtmlTags(text);
  if (text.length > 140) {
    text = text.substring(0, 140);
  }
  return text;
}

FeedItem formatRssItem(RssItem item) {
  DateTime pubDate;
  try {
    pubDate = DateTime.parse(item.pubDate ?? "");
  } on FormatException catch (e) {}
  ;
  return FeedItem(
      item.title, // tile
      formatRssItemText(item.description ?? ""), // description
      item.link, // link
      pubDate // date
      );
}

class FeedItem {
  String title, description, link;
  DateTime pubDate;

  FeedItem(this.title, this.description, this.link, [this.pubDate]);
}
