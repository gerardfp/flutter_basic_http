import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Robots'),
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
  var data;

  @override
  void initState() {
    super.initState();

    getRobots();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text(widget.title),),
        body: RefreshIndicator(
          onRefresh: () async { await getRobots(); return true; },
          child: GridView.builder(
            itemCount: data != null ? data['response'].length : 0,
            itemBuilder: (context, index) =>
                Column(
                  children: [
                    Expanded(
                      child: SizedBox.expand(
                          // child: Image.network(data['response'][index]['src'])
                        child: FadeInImage.assetNetwork(placeholder: "images/placeholder.png", image: data['response'][index]['src'],)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data['response'][index]['name']),
                    ),
                  ],
                ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
            ),
          ),
        )
    );
  }

  getRobots() async {
    var resp = await json.decode((await http.get(Uri.parse("https://yopi.herokuapp.com/robots"))).body);

    setState(() {
      data = resp;
    });
  }
}
