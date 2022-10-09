import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  //debugPaintSizeEnabled = true;
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Конвертер файлов',
      //theme: ThemeData(primarySwatch: Colors.c),
      home: HomePage(),
    );
  }
}


