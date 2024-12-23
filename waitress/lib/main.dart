import 'package:flutter/material.dart';
import "pages/home.dart";
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(240, 255, 255, 255),
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced:true,
    systemNavigationBarColor:Color.fromARGB(255, 255, 255, 255),
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shef',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 248, 32, 79)),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}
