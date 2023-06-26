# gh_calendar Package

The **gh_calendar** package provides a simple and intuitive way to implement date selection functionalities in Flutter applications. It allows users to select a single date or a date range effortlessly.

## Features

- **Single Date Selection:** Users can select a single date from the calendar.
- **Date Range Selection:** Users can select a range of dates by choosing a start date and an end date.

## Installation

To use the **gh_calendar** package, follow these steps:

1. Add the package to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     gh_calendar: ^0.1.0
   ```

2. Run `flutter pub get` to fetch the package.

## Usage

1. Import the package in your Dart file:

   ```dart
   import 'package:gh_calendar/gh_calendar.dart';
   ```

2. Create a `GhCalendar` widget in your widget tree:

   ```dart
   GhCalendar(
       isPeriodSelect: true,
       activeMinDate: DateTime.now().add(const Duration(days: -1)),
       onChanged: (dateTimes) {
         /// some code...
       },
   )
   ```

3. Customize the appearance and behavior of the calendar using the available parameters.

4. Access the selected date or date range using the callback functions provided (`onDateSelected` and `onDateRangeSelected`).

## Example

Here's a simple example of using the **gh_calendar** package:

```dart
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
            activeMinDate: DateTime.now().add(const Duration(days: -1)),
            onChanged: (dateTimes) {

            },
          ),
        ),
      ),
    );
  }
}

```

## Support

For any issues or feature requests, please create a new issue on the [GitHub repository](https://github.com/Gyeony95/GH-Calendar/issues).

---

Feel free to modify the markdown file according to the specific details and usage instructions of the "gh_calendar" package.