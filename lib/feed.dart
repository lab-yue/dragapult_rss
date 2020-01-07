import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
//import 'dart:developer' as developer;
//import 'package:webfeed/webfeed.dart';
import './dummy.dart' as dummy;
import './helper.dart' as helper;

const List<String> feedList = [
  'https://news.ycombinator.com/rss',
  //'https://news.vuejs.org/feed.xml',
  //'https://coolshell.cn/feed'
];

Future<List<FeedItem>> fetch() async {
  //var res = await Future.wait(feedList.map((source) => http.get(source)));
  var res = [dummy.vueFeed, dummy.coolSheelFeed];
  return res
      .expand((f) {
        var feed = new RssFeed.parse(f);
        return feed.items.map((item) => [feed, item]);
      })
      .map((i) => formatRssItem(i[0], i[1]))
      .toList();
}

String formatRssItemText(String text) {
  text = helper.removeAllHtmlTags(text).replaceAll("\n", "");
  if (text.length > 140) {
    text = text.substring(0, 140);
  }
  return text;
}

FeedItem formatRssItem(RssFeed feed, RssItem item) {
  DateTime pubDate;
  try {
    pubDate = DateTime.parse(item.pubDate ?? "");
  } on FormatException catch (e) {}
  ;
  return FeedItem(
    feed.title ?? "",
    item.title, // tile
    formatRssItemText(item.description ?? ""), // description
    item.link, // link
    pubDate, // date
  );
}

class FeedItem {
  String feedTitle, title, description, link;
  DateTime pubDate;

  FeedItem(this.feedTitle, this.title, this.description, this.link,
      [this.pubDate]);
}
