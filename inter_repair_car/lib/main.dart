import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Routes/AppPage.dart';
import 'package:inter_repair_car/Widgets/navigation_menu.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey[800],
  hintColor: Colors.cyan[600],
  scaffoldBackgroundColor: Colors.grey[900],
  cardTheme: CardTheme(
    color: Colors.grey[850],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 4.0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  appBarTheme: AppBarTheme(color: Colors.blueGrey[800], elevation: 0),
);

void main() async {
  runApp(const MyApp());

  // DatabaseHelper db = DatabaseHelper();
  // db.deleteDatabasef();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: Apppage.pages,
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const NavigationMenu(),
    );
  }
}
