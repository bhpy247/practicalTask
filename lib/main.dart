import 'package:flutter/material.dart';

import 'package:practical_task/tilesList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          //
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ), initialRoute: '/',
        routes: {
          '/': (context) => TileListScreen(),
        } );
  }
}


