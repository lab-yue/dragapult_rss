import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import './feed.dart' as feed;

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dragapult',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Dragapult rss'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget createRegionsListView(context, snapshot) {
    List<RssItem> values = snapshot.data;
    return ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return values.isNotEmpty
            ? Column(
                children: <Widget>[
                  ListTile(
                    title: Text(values[index].description ?? "$index"),
                  ),
                  Divider(
                    height: 2.0,
                  ),
                ],
              )
            : CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: feed.fetch(),
          initialData: [],
          builder: (context, snapshot) {
            return createRegionsListView(context, snapshot);
          }),
    );
  }
}
