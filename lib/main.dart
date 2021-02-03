import 'package:asset_cache/asset_cache.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  JsonAssets.instance.basePath = 'assets/';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "من سيربح الشدات",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: homepage(),


    );
  }
}