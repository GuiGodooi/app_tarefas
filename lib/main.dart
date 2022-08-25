import 'package:app_listatarefas/view/tarefas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
