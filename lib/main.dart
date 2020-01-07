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
  Widget createRegionsListView(context, snapshot) {
    var values = snapshot.data;
    return values.isNotEmpty
        ? ListView.builder(
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemView(values[index]);
            },
          )
        : CircularProgressIndicator();
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
      drawer: DrawerView(),
    );
  }
}
