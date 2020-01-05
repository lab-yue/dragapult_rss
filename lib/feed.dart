import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
//import 'dart:developer' as developer;
//import 'package:webfeed/webfeed.dart';
import './dummy.dart' as dummy;

const List<String> feedList = [
  'https://news.vuejs.org/feed.xml',
  'https://coolshell.cn/feed'
];

Future<List<RssItem>> fetch() async {
  //var res = await http.get(feedList[0]);
  //var rssFeed = new RssFeed.parse(res.body);
  var res = [dummy.vueFeed, dummy.coolSheelFeed];
  var rssFeed = res.expand((f) => (new RssFeed.parse(f).items));
  return rssFeed.toList();
}
