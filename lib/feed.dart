import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './dummy.dart' as dummy;
import './helper.dart' as helper;

const List<String> feedList = [
  'https://news.ycombinator.com/rss',
  //'https://news.vuejs.org/feed.xml',
  //'https://coolshell.cn/feed'
];

Future<List<FeedItem>> fetch() async {
  //var res = await Future.wait(feedList.map((source) => http.get(source)));
  var res = [dummy.vueFeed, dummy.coolSheelFeed, dummy.hnFeed];
  return res.expand((f) {
    var feed = new RssFeed.parse(f);
    return feed.items.map((item) => formatRssItem(feed, item));
  }).toList();
}

String formatRssItemText(String text) {
  text = helper.removeAllHtmlTags(text).replaceAll("\n", "");
  if (text.length > 140) {
    text = text.substring(0, 140);
  }
  return text;
}

FeedItem formatRssItem(RssFeed feed, RssItem item) {
  dynamic pubDate;
  try {
    pubDate = DateTime.parse(item.pubDate ?? "");
  } on FormatException catch (e) {}
  ;
  return FeedItem(
    feedTitle: feed.title ?? "",
    title: item.title, // tile
    description: formatRssItemText(item.description ?? ""), // description
    link: item.link, // link
    pubDate: pubDate, // date
  );
}

class FeedItem {
  String feedTitle, title, description, link;
  DateTime pubDate;
  bool read;
  bool star;

  FeedItem(
      {this.feedTitle,
      this.title,
      this.description,
      this.link,
      this.read = false,
      this.star = false,
      this.pubDate});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'link': link,
      'pubDate': pubDate,
      'read': read,
      'star': star,
      'feedTitle': feedTitle
    };
  }
}

class FeedService {
  Future<Database> getDB() async {
    return openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'doggie_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          """CREATE TABLE feeds(
          `id` INTEGER PRIMARY KEY,
          `title` TEXT,
          `description` TEXT,
          `link` TEXT,
          `pubDate` DATETIME,
          `read` BOOLEAN,
          `star` BOOLEAN,
          `feedTitle` TEXT
          )
          """,
        );
      },
      version: 1,
    );
  }

  Future<void> insert(FeedItem feed) async {
    final Database db = await getDB();

    await db.insert(
      'feeds',
      feed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMany(List<FeedItem> feeds) async {
    final Database db = await getDB();
    await Future.wait(feeds.map((feed) {
      return db.insert(
        'feeds',
        feed.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }));
  }

  Future<List<FeedItem>> getAll() async {
    final Database db = await getDB();
    final List<Map<String, dynamic>> feedsData = await db.query('feeds');

    return feedsData.map((f) {
      return FeedItem(
        feedTitle: f['feedTitle'],
        title: f['title'],
        description: f['description'],
        link: f['link'],
        pubDate: f['pubDate'],
        read: f['read'],
        star: f['star'],
      );
    });
  }
}
