import 'package:flutter/material.dart';
import 'package:gh_calendar/gh_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GH Calendar Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GhCalendar(
            isPeriodSelect: true,
            useGrid: true,
            dayAlignment: Alignment.topLeft,
            activeMinDate: DateTime.now().add(const Duration(days: -1)),
            onChanged: (dateTimes) {

            },
          ),
        ),
      ),
    );
  }
}
