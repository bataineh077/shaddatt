import 'package:asset_cache/asset_cache.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'home/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  JsonAssets.instance.basePath = 'assets/';
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: "من سيربح الشدات",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: homepage(),


    );
  }
}