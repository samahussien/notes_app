import 'package:flutter/material.dart';
import 'package:notes/pages/note_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.lightGreen[50],
          splashColor: Colors.green,
          sliderTheme: SliderThemeData(activeTrackColor: Colors.green,inactiveTrackColor: Colors.lightGreen[200]),
          iconTheme: const IconThemeData(color: Colors.white),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.lightGreen)),
      home: const NotesPage(),
    );
  }
}
