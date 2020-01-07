import 'package:flutter/material.dart';
import './feed.dart' as feed;
import './itemView.dart';
import './drawer.dart';

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
      home: MyHomePage(title: 'Dragapult RSS'),
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
  Future<List<feed.FeedItem>> _future;

  initState() {
    super.initState();
    _future = feed.fetch();
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
          future: _future,
          initialData: [],
          builder: (context, snapshot) {
            var values = snapshot.data;
            return values.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (BuildContext context, int index) {
                      feed.FeedItem item = values[index];
                      return Dismissible(
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            snapshot.data.removeAt(index);
                          });
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(item.title + " dismissed")));
                        },
                        key: Key(item.title ?? item.description),
                        child: ItemView(item),
                        background: Container(color: Colors.grey[200]),
                      );
                    },
                  );
          }),
      drawer: DrawerView(),
    );
  }
}
